import { StackProps } from "aws-cdk-lib";
import { enterpriseCloud, Location, PrivatePackage } from "./common-interface";

export interface ECSstackProps extends StackProps {
  vpcId: string;
  availabilityZones: string[];
  subnetIds: string[];
  securityGroupIds: string[];
  ecsTaskRoleArn: string;
  name: string;
  description: string;
  image: string;
  command?: string[];
  environment?: Record<string, string>;
  secrets?: Record<string, string>;
  locations: Location[];
  privatePackage?: PrivatePackage;
  cloudWatchLogs?: boolean;
  enterpriseCloud?: enterpriseCloud;
}
