package com.gatlingenterprise.stacks;

import com.gatlingenterprise.records.controlPlaneProps.IAMStackProps;
import com.gatlingenterprise.records.packageProps.PrivatePackage;
import java.util.List;
import software.amazon.awscdk.NestedStack;
import software.amazon.awscdk.services.iam.Effect;
import software.amazon.awscdk.services.iam.ManagedPolicy;
import software.amazon.awscdk.services.iam.PolicyStatement;
import software.amazon.awscdk.services.iam.Role;
import software.amazon.awscdk.services.iam.ServicePrincipal;
import software.constructs.Construct;

public class IAMstack extends NestedStack {
  public static String ecsTaskRoleArn;

  public IAMstack(Construct scope, String id, IAMStackProps props) {
    super(scope, id, props);

    String name = props.name();
    PrivatePackage privatePackage = props.privatePackage();
    boolean cloudWatchLogs = props.cloudWatchLogs();
    boolean useECR = props.useECR();

    Role ecsTaskRole =
        Role.Builder.create(this, "ECSTaskRole")
            .roleName(name)
            .assumedBy(new ServicePrincipal("ecs-tasks.amazonaws.com"))
            .build();

    ManagedPolicy.Builder.create(this, "EC2Policy")
        .managedPolicyName(name + "-EC2Policy")
        .statements(
            List.of(
                PolicyStatement.Builder.create()
                    .effect(Effect.ALLOW)
                    .actions(
                        List.of(
                            "ec2:Describe*",
                            "ec2:CreateTags",
                            "ec2:RunInstances",
                            "ec2:TerminateInstances",
                            "ec2:AssociateAddress",
                            "ec2:DisassociateAddress"))
                    .resources(List.of("*"))
                    .build()))
        .roles(List.of(ecsTaskRole))
        .build();

    if (useECR) {
      ManagedPolicy.Builder.create(this, "ECRPolicy")
          .managedPolicyName(name + "-ECRPolicy")
          .statements(
              List.of(
                  PolicyStatement.Builder.create()
                      .effect(Effect.ALLOW)
                      .actions(
                          List.of(
                              "ecr:GetAuthorizationToken",
                              "ecr:BatchCheckLayerAvailability",
                              "ecr:GetDownloadUrlForLayer",
                              "ecr:BatchGetImage"))
                      .resources(List.of("*"))
                      .build()))
          .roles(List.of(ecsTaskRole))
          .build();
    }

    if (cloudWatchLogs) {
      ManagedPolicy.Builder.create(this, "CloudWatchLogsPolicy")
          .managedPolicyName(name + "-CloudWatchLogsPolicy")
          .statements(
              List.of(
                  PolicyStatement.Builder.create()
                      .effect(Effect.ALLOW)
                      .actions(
                          List.of(
                              "logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"))
                      .resources(List.of("*"))
                      .build()))
          .roles(List.of(ecsTaskRole))
          .build();
    }

    if (privatePackage != null) {
      ManagedPolicy.Builder.create(this, "PrivatePackagePolicy")
          .managedPolicyName(name + "-PackagePolicy")
          .statements(
              List.of(
                  PolicyStatement.Builder.create()
                      .effect(Effect.ALLOW)
                      .actions(List.of("s3:GetObject", "s3:PutObject", "s3:DeleteObject"))
                      .resources(
                          List.of(
                              "arn:aws:s3:::"
                                  + privatePackage.bucket()
                                  + "/"
                                  + privatePackage.path()
                                  + "/*"))
                      .build()))
          .roles(List.of(ecsTaskRole))
          .build();
    }

    ecsTaskRoleArn = ecsTaskRole.getRoleArn();
  }
}
