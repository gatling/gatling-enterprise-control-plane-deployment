import { StackProps } from "aws-cdk-lib";
import { ISecret } from "aws-cdk-lib/aws-secretsmanager";
import { enterpriseCloud, Location, PrivatePackage } from "./common-interface";

export interface ControlPlaneProps extends StackProps {
  vpcId: string;
  availabilityZones: string[];
  subnetIds: string[];
  securityGroupIds: string[];
  tokenSecretARN: string;
  name: string;
  description: string;
  image: string;
  command?: string[];
  environment?: Record<string, string>;
  secrets?: Record<string, ISecret>;
  locations: Location[];
  privatePackage?: PrivatePackage;
  cloudWatchLogs?: boolean;
  useECR?: boolean;
  enterpriseCloud?: enterpriseCloud;
}
