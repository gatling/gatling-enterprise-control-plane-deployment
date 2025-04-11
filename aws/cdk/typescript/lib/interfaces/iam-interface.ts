import { StackProps } from "aws-cdk-lib";
import { Location, PrivatePackage } from "./common-interface";

export interface IAMstackProps extends StackProps {
  name: string;
  ecr?: boolean;
  locations: Location[];
  privatePackage?: PrivatePackage;
}
