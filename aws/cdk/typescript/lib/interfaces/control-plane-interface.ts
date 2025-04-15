import { StackProps } from "aws-cdk-lib";
import {Task, Location, enterpriseCloud, PrivatePackage } from "./common-interface";

export interface ControlPlaneProps extends StackProps {
  name: string;
  description?: string;
  tokenSecretArn: string;
  vpcId: string;
  availabilityZones: string[];
  subnets: string[];
  securityGroups: string[];
  locations: Location[];
  task?: Task;
  privatePackage?: PrivatePackage;
  enterpriseCloud?: enterpriseCloud;
}
