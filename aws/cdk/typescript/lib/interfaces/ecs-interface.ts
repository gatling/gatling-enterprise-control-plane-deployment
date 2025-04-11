import { StackProps } from "aws-cdk-lib";
import { Task, Location, PrivatePackage, enterpriseCloud } from "./common-interface";

export interface ECSstackProps extends StackProps {
  name: string;
  description: string;
  vpcId: string;
  availabilityZones: string[];
  subnets: string[];
  securityGroups: string[];
  ecsTaskRoleArn: string;
  task: Task;
  locations: Location[];
  privatePackage?: PrivatePackage;
  enterpriseCloud?: enterpriseCloud;
}
