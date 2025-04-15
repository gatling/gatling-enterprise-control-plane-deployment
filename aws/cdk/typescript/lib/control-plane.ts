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
      name,
      description = "My AWS control plane description",
      tokenSecretArn,
      vpcId,
      availabilityZones,
      subnets,
      securityGroups,
      task,
      locations,
      privatePackage,
      enterpriseCloud = { proxy: {} },
    } = props;

    const IAM = new IAMstack(this, "iam", {
      name,
      ecr: task?.ecr ?? false,
      locations,
      privatePackage,
    });

    new ECSstack(this, "ecs", {
      name,
      description,
      vpcId,
      availabilityZones,
      subnets,
      securityGroups,
      ecsTaskRoleArn: IAM.ecsTaskRoleArn,
      task: {
        ...task,
        secrets: { CONTROL_PLANE_TOKEN: tokenSecretArn, ...task?.secrets },
      },
      locations,
      privatePackage,
      enterpriseCloud,
    });
  }
}
