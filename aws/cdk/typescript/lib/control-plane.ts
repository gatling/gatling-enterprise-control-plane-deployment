import "source-map-support/register";
import { Stack } from "aws-cdk-lib";
import { Construct } from "constructs";
import { ECSstack } from "./stacks/ecs-stack";
import { IAMstack } from "./stacks/iam-stack";
import { ControlPlaneProps } from "./interfaces/control-plane-interface";

export class ControlPlaneStack extends Stack {
  constructor(scope: Construct, id: string, props: ControlPlaneProps) {
    super(scope, id, props);

    const {
      vpcId,
      subnetIds,
      availabilityZones,
      securityGroupIds,
      tokenSecretARN,
      name,
      description,
      image,
      command = [],
      environment = {},
      secrets = {},
      locations,
      privatePackage,
      cloudWatchLogs = true,
      useECR = false,
      enterpriseCloud = {}
    } = props;

    const IAM = new IAMstack(this, "iam", {
      name,
      privatePackage,
      cloudWatchLogs,
      useECR
    });

    new ECSstack(this, "ecs", {
      vpcId,
      availabilityZones,
      subnetIds,
      securityGroupIds,
      ecsTaskRoleArn: IAM.ecsTaskRoleArn,
      name,
      description,
      image,
      command,
      environment,
      secrets: { CONTROL_PLANE_TOKEN: tokenSecretARN, ...secrets },
      locations,
      privatePackage,
      cloudWatchLogs,
      enterpriseCloud
    });
  }
}
