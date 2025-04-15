import { Aws, NestedStack } from "aws-cdk-lib";
import { Construct } from "constructs";
import {
  Role,
  ServicePrincipal,
  PolicyStatement,
  Effect,
} from "aws-cdk-lib/aws-iam";
import { IAMstackProps } from "../interfaces/iam-interface";

export class IAMstack extends NestedStack {
  public readonly ecsTaskRoleArn: string;

  constructor(scope: Construct, id: string, props: IAMstackProps) {
    super(scope, id, props);

    const { name, ecr, locations, privatePackage } = props;

    const ecsTaskRole = new Role(this, "ECSTaskRole", {
      roleName: name,
      assumedBy: new ServicePrincipal("ecs-tasks.amazonaws.com"),
    });

    ecsTaskRole.addToPolicy(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: ["ec2:CreateTags", "ec2:RunInstances"],
        resources: [
          "arn:aws:ec2:*:*:instance/*",
          "arn:aws:ec2:*:*:network-interface/*",
          "arn:aws:ec2:*:*:security-group/*",
          "arn:aws:ec2:*:*:subnet/*",
          "arn:aws:ec2:*:*:volume/*",
          "arn:aws:ec2:*::image/*",
        ],
      })
    );

    ecsTaskRole.addToPolicy(
      new PolicyStatement({
        sid: "EnforceGatlingTag",
        effect: Effect.DENY,
        actions: ["ec2:RunInstances"],
        resources: ["arn:aws:ec2:*:*:instance/*"],
        conditions: {
          StringNotLike: {
            "aws:RequestTag/Name": "GATLING_LG_*",
          },
        },
      })
    );

    ecsTaskRole.addToPolicy(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: ["ec2:TerminateInstances"],
        resources: ["arn:aws:ec2:*:*:instance/*"],
        conditions: {
          StringLike: {
            "ec2:ResourceTag/Name": "GATLING_LG_*",
          },
        },
      })
    );

    ecsTaskRole.addToPolicy(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: ["ec2:DescribeImages", "ec2:DescribeInstances"],
        resources: ["*"],
      })
    );

    const hasElasticIPs = locations.some(
      (location) =>
        location["elastic-ips"] && location["elastic-ips"].length > 0
    );

    if (hasElasticIPs) {
      ecsTaskRole.addToPolicy(
        new PolicyStatement({
          effect: Effect.ALLOW,
          actions: ["ec2:DisassociateAddress", "ec2:AssociateAddress"],
          resources: ["arn:aws:ec2:*:*:instance/*"],
          conditions: {
            StringLike: {
              "ec2:ResourceTag/Name": "GATLING_LG_*",
            },
          },
        })
      );

      ecsTaskRole.addToPolicy(
        new PolicyStatement({
          effect: Effect.ALLOW,
          actions: [
            "ec2:DescribeAddresses",
            "ec2:DisassociateAddress",
            "ec2:AssociateAddress",
          ],
          resources: ["arn:aws:ec2:*:*:elastic-ip/*"],
        })
      );
    }

    const roleArns = locations
      .filter((location) => location["iam-instance-profile"])
      .map(
        (location) =>
          `arn:aws:iam::${Aws.ACCOUNT_ID}:role/${location["iam-instance-profile"]}`
      );

    if (roleArns.length > 0) {
      ecsTaskRole.addToPolicy(
        new PolicyStatement({
          effect: Effect.ALLOW,
          actions: ["iam:PassRole"],
          resources: roleArns,
        })
      );
    }

    if (ecr === true) {
      ecsTaskRole.addToPolicy(
        new PolicyStatement({
          effect: Effect.ALLOW,
          actions: [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
          ],
          resources: ["*"],
        })
      );
    }

    if (privatePackage) {
      ecsTaskRole.addToPolicy(
        new PolicyStatement({
          effect: Effect.ALLOW,
          actions: ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
          resources: [
            `arn:aws:s3:::${privatePackage.bucket}/${privatePackage.path}/*`,
          ],
        })
      );
    }

    this.ecsTaskRoleArn = ecsTaskRole.roleArn;
  }
}
