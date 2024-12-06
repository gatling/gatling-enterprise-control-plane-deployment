import { NestedStack } from "aws-cdk-lib";
import { Construct } from "constructs";
import {
  Role,
  ServicePrincipal,
  ManagedPolicy,
  PolicyStatement,
  Effect
} from "aws-cdk-lib/aws-iam";
import { IAMstackProps } from "../interfaces/iam-interface";

export class IAMstack extends NestedStack {
  public readonly ecsTaskRoleArn: string;

  constructor(scope: Construct, id: string, props: IAMstackProps) {
    super(scope, id, props);

    const { name, privatePackage, cloudWatchLogs, useECR } = props;

    const ecsTaskRole = new Role(this, "ECSTaskRole", {
      roleName: name,
      assumedBy: new ServicePrincipal("ecs-tasks.amazonaws.com")
    });

    new ManagedPolicy(this, "EC2Policy", {
      managedPolicyName: `${name}-EC2Policy`,
      statements: [
        new PolicyStatement({
          effect: Effect.ALLOW,
          actions: [
            "ec2:Describe*",
            "ec2:CreateTags",
            "ec2:RunInstances",
            "ec2:TerminateInstances",
            "ec2:AssociateAddress",
            "ec2:DisassociateAddress"
          ],
          resources: ["*"]
        })
      ],
      roles: [ecsTaskRole]
    });

    if (useECR === true) {
      new ManagedPolicy(this, "ECRPolicy", {
        managedPolicyName: `${name}-ECRPolicy`,
        statements: [
          new PolicyStatement({
            effect: Effect.ALLOW,
            actions: [
              "ecr:GetAuthorizationToken",
              "ecr:BatchCheckLayerAvailability",
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage"
            ],
            resources: ["*"]
          })
        ],
        roles: [ecsTaskRole]
      });
    }

    if (cloudWatchLogs === true) {
      new ManagedPolicy(this, "CloudWatchLogsPolicy", {
        managedPolicyName: `${name}-CloudWatchLogsPolicy`,
        statements: [
          new PolicyStatement({
            effect: Effect.ALLOW,
            actions: ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
            resources: ["*"]
          })
        ],
        roles: [ecsTaskRole]
      });
    }

    if (privatePackage) {
      new ManagedPolicy(this, "PrivatePackagePolicy", {
        managedPolicyName: `${name}-PackagePolicy`,
        statements: [
          new PolicyStatement({
            effect: Effect.ALLOW,
            actions: ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
            resources: [`arn:aws:s3:::${privatePackage.bucket}/${privatePackage.path}/*`]
          })
        ],
        roles: [ecsTaskRole]
      });
    }

    this.ecsTaskRoleArn = ecsTaskRole.roleArn;
  }
}
