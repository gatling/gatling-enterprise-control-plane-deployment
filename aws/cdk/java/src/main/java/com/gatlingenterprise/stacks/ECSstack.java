package com.gatlingenterprise.stacks;

import com.gatlingenterprise.records.controlPlaneProps.ECSstackProps;
import com.gatlingenterprise.records.locationProps.EnterpriseCloud;
import com.gatlingenterprise.utils.ControlPlaneConfigGenerator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import software.amazon.awscdk.NestedStack;
import software.amazon.awscdk.RemovalPolicy;
import software.amazon.awscdk.services.ec2.IVpc;
import software.amazon.awscdk.services.ec2.SecurityGroup;
import software.amazon.awscdk.services.ec2.Subnet;
import software.amazon.awscdk.services.ec2.SubnetSelection;
import software.amazon.awscdk.services.ec2.Vpc;
import software.amazon.awscdk.services.ec2.VpcAttributes;
import software.amazon.awscdk.services.ecs.*;
import software.amazon.awscdk.services.iam.IRole;
import software.amazon.awscdk.services.iam.Role;
import software.amazon.awscdk.services.logs.LogGroup;
import software.amazon.awscdk.services.logs.RetentionDays;
import software.amazon.awscdk.services.secretsmanager.ISecret;
import software.constructs.Construct;

public class ECSstack extends NestedStack {
  public ECSstack(Construct scope, String id, ECSstackProps props) {
    super(scope, id, props);

    String vpcId = props.vpcId();
    List<String> availabilityZones = props.availabilityZones();
    List<String> subnetIds = props.subnetIds();
    List<String> securityGroupIds = props.securityGroupIds();
    String name = props.name();
    Map<String, ISecret> secrets = props.secrets();
    String desc = props.desc();
    String ecsTaskRoleArn = props.ecsTaskRoleArn();
    String image = props.image();
    Map<String, String> environment = props.environment();
    List<String> command = props.command();
    var locations = props.locations();
    var privatePackage = props.privatePackage();
    boolean cloudWatchLogs = props.cloudWatchLogs();
    EnterpriseCloud enterpriseCloud = props.enterpriseCloud();

    String volumeName = "control-plane-conf";
    String path = "/app/conf";

    ControlPlaneConfigGenerator configGenerator =
        new ControlPlaneConfigGenerator(desc, locations, privatePackage, enterpriseCloud);
    String configContent = configGenerator.generateConfig();

    IVpc vpc =
        Vpc.fromVpcAttributes(
            this,
            "ExistingVpc",
            VpcAttributes.builder()
                .vpcId(vpcId)
                .availabilityZones(availabilityZones)
                .privateSubnetIds(subnetIds)
                .build());

    Cluster cluster =
        new Cluster(
            this,
            "GatlingEnterpriseCluster",
            ClusterProps.builder().clusterName(name + "-cluster").vpc(vpc).build());

    IRole taskRole = Role.fromRoleArn(this, "EcsTaskRole", ecsTaskRoleArn);

    LogGroup logGroup =
        cloudWatchLogs
            ? LogGroup.Builder.create(this, "LogGroup")
                .logGroupName("/ecs/" + name + "-service")
                .retention(RetentionDays.ONE_MONTH)
                .removalPolicy(RemovalPolicy.DESTROY)
                .build()
            : null;

    FargateTaskDefinition taskDefinition =
        FargateTaskDefinition.Builder.create(this, "GatlingTaskDefinition")
            .family(name + "-task")
            .taskRole(taskRole)
            .executionRole(taskRole)
            .cpu(1024)
            .memoryLimitMiB(3072)
            .volumes(List.of(Volume.builder().name(volumeName).build()))
            .build();

    ContainerDefinition initContainer =
        taskDefinition.addContainer(
            "ConfLoaderInitContainer",
            ContainerDefinitionOptions.builder()
                .image(ContainerImage.fromRegistry("busybox"))
                .essential(false)
                .environment(Map.of("CONFIG_CONTENT", configContent))
                .command(
                    List.of(
                        "/bin/sh",
                        "-c",
                        "echo \"$CONFIG_CONTENT\" > "
                            + path
                            + "/control-plane.conf; echo \"$CONFIG_CONTENT\""))
                .readonlyRootFilesystem(false)
                .logging(
                    cloudWatchLogs
                        ? LogDrivers.awsLogs(
                            AwsLogDriverProps.builder()
                                .logGroup(logGroup)
                                .streamPrefix("init")
                                .build())
                        : null)
                .build());

    initContainer.addMountPoints(
        MountPoint.builder().sourceVolume(volumeName).containerPath(path).readOnly(false).build());

    Map<String, Secret> ecsSecrets =
        secrets != null
            ? secrets.entrySet().stream()
                .filter(entry -> entry.getValue() != null)
                .collect(
                    Collectors.toMap(
                        Map.Entry::getKey, entry -> Secret.fromSecretsManager(entry.getValue())))
            : Map.of();

    ContainerDefinition controlPlaneContainer =
        taskDefinition.addContainer(
            "ControlPlaneContainer",
            ContainerDefinitionOptions.builder()
                .image(ContainerImage.fromRegistry(image))
                .essential(true)
                .secrets(ecsSecrets)
                .environment(environment)
                .command(command)
                .workingDirectory(path)
                .portMappings(
                    privatePackage != null
                        ? List.of(
                            PortMapping.builder()
                                .containerPort(
                                    privatePackage.server() != null
                                            && privatePackage.server().port() != null
                                        ? privatePackage.server().port()
                                        : 8080)
                                .hostPort(
                                    privatePackage.server() != null
                                            && privatePackage.server().port() != null
                                        ? privatePackage.server().port()
                                        : 8080)
                                .protocol(Protocol.TCP)
                                .build())
                        : List.of())
                .logging(
                    cloudWatchLogs
                        ? LogDrivers.awsLogs(
                            AwsLogDriverProps.builder()
                                .logGroup(logGroup)
                                .streamPrefix("main")
                                .build())
                        : null)
                .build());

    controlPlaneContainer.addMountPoints(
        MountPoint.builder().sourceVolume(volumeName).containerPath(path).readOnly(true).build());

    controlPlaneContainer.addContainerDependencies(
        ContainerDependency.builder()
            .container(initContainer)
            .condition(ContainerDependencyCondition.SUCCESS)
            .build());

    FargateService.Builder.create(this, "GatlingEnterpriseService")
        .serviceName(name + "-service")
        .cluster(cluster)
        .taskDefinition(taskDefinition)
        .desiredCount(1)
        .assignPublicIp(true)
        .vpcSubnets(
            SubnetSelection.builder()
                .subnets(
                    subnetIds.stream()
                        .map(subnetId -> Subnet.fromSubnetId(this, "Subnet-" + subnetId, subnetId))
                        .toList())
                .build())
        .securityGroups(
            securityGroupIds.stream()
                .map(sgId -> SecurityGroup.fromSecurityGroupId(this, "SecurityGroup-" + sgId, sgId))
                .toList())
        .build();
  }
}
