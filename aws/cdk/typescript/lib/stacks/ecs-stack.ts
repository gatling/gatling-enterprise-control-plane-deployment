import { NestedStack, RemovalPolicy } from "aws-cdk-lib";
import {
  Cluster,
  FargateTaskDefinition,
  FargateService,
  ContainerImage,
  Protocol,
  LogDrivers,
  ContainerDependencyCondition,
  Secret as EcsSecret,
} from "aws-cdk-lib/aws-ecs";
import { Vpc, Subnet, SecurityGroup } from "aws-cdk-lib/aws-ec2";
import { Secret } from "aws-cdk-lib/aws-secretsmanager";
import { Role } from "aws-cdk-lib/aws-iam";
import { LogGroup, RetentionDays } from "aws-cdk-lib/aws-logs";
import { Construct } from "constructs";
import { ECSstackProps } from "../interfaces/ecs-interface";

export class ECSstack extends NestedStack {
  constructor(scope: Construct, id: string, props: ECSstackProps) {
    super(scope, id, props);

    const {
      vpcId,
      availabilityZones,
      subnetIds,
      securityGroupIds,
      name,
      description,
      ecsTaskRoleArn,
      image,
      command,
      secrets,
      environment,
      locations,
      privatePackage,
      cloudWatchLogs,
      enterpriseCloud,
    } = props;

    const volumeNname: string = "control-plane-conf";
    const path: string = "/app/conf";

    const configContent: string = `
      {
        "control-plane": {
          token = \${?CONTROL_PLANE_TOKEN},
          description: ${description},
          enterprise-cloud: ${JSON.stringify(enterpriseCloud)},
          locations: ${JSON.stringify(
            locations.map((location) => ({
              type: "aws",
              ...location,
            }))
          )},
          repository: ${JSON.stringify(privatePackage ? { type: "aws", ...privatePackage } : {})}
        }
      }
      `;

    const vpc = Vpc.fromVpcAttributes(this, "ExistingVpc", {
      vpcId: vpcId,
      availabilityZones: availabilityZones,
      privateSubnetIds: subnetIds,
    });

    const cluster = new Cluster(this, "GatlingEnterpriseCluster", {
      clusterName: `${name}-cluster`,
      vpc,
    });

    const taskRole = Role.fromRoleArn(this, "EcsTaskRole", ecsTaskRoleArn);

    const logGroup = cloudWatchLogs
      ? new LogGroup(this, "LogGroup", {
          logGroupName: `/ecs/${name}-service`,
          retention: RetentionDays.ONE_MONTH,
          removalPolicy: RemovalPolicy.DESTROY,
        })
      : undefined;

    const taskDefinition = new FargateTaskDefinition(
      this,
      "GatlingTaskDefinition",
      {
        family: `${name}-task`,
        taskRole,
        executionRole: taskRole,
        cpu: 1024,
        memoryLimitMiB: 3072,
        volumes: [
          {
            name: volumeNname,
          },
        ],
      }
    );

    const initContainer = taskDefinition.addContainer(
      "ConfLoaderInitContainer",
      {
        image: ContainerImage.fromRegistry("busybox"),
        essential: false,
        environment: {
          CONFIG_CONTENT: configContent,
        },
        command: [
          "/bin/sh",
          "-c",
          `echo "$CONFIG_CONTENT" > ${path}/control-plane.conf`,
        ],
        readonlyRootFilesystem: false,
        logging: cloudWatchLogs
          ? LogDrivers.awsLogs({
              logGroup,
              streamPrefix: "init",
            })
          : undefined,
      }
    );

    initContainer.addMountPoints({
      sourceVolume: volumeNname,
      containerPath: path,
      readOnly: false,
    });

    const ecsSecrets: { [key: string]: EcsSecret } = {};
    if (secrets) {
      for (const [key, secretArn] of Object.entries(secrets)) {
        if (secretArn) {
          const secret = Secret.fromSecretCompleteArn(
            this,
            "ImportedSecret",
            secretArn
          );
          ecsSecrets[key] = EcsSecret.fromSecretsManager(secret);
          secret.grantRead(taskDefinition.taskRole);
        }
      }
    }

    const controlPlaneContainer = taskDefinition.addContainer(
      "ControlPlaneContainer",
      {
        image: ContainerImage.fromRegistry(image),
        essential: true,
        secrets: ecsSecrets,
        environment: environment,
        command: command,
        workingDirectory: path,
        portMappings: privatePackage
          ? [
              {
                containerPort: privatePackage?.server?.port
                  ? privatePackage?.server?.port
                  : 8080,
                hostPort: privatePackage?.server?.port
                  ? privatePackage?.server?.port
                  : 8080,
                protocol: Protocol.TCP,
              },
            ]
          : [],
        logging: cloudWatchLogs
          ? LogDrivers.awsLogs({
              logGroup,
              streamPrefix: "main",
            })
          : undefined,
      }
    );

    controlPlaneContainer.addMountPoints({
      sourceVolume: volumeNname,
      containerPath: path,
      readOnly: true,
    });

    controlPlaneContainer.addContainerDependencies({
      container: initContainer,
      condition: ContainerDependencyCondition.SUCCESS,
    });

    new FargateService(this, "GatlingEnterpriseService", {
      serviceName: `${name}-service`,
      cluster,
      taskDefinition,
      desiredCount: 1,
      assignPublicIp: true,
      vpcSubnets: {
        subnets: subnetIds.map((subnetId) =>
          Subnet.fromSubnetId(this, subnetId, subnetId)
        ),
      },
      securityGroups: securityGroupIds.map((sgId) =>
        SecurityGroup.fromSecurityGroupId(this, `SecurityGroup-${sgId}`, sgId)
      ),
    });
  }
}
