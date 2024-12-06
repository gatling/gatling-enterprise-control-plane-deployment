import { StackProps } from "aws-cdk-lib";
import { PrivatePackage } from "./common-interface";

export interface IAMstackProps extends StackProps {
  name: string;
  privatePackage?: PrivatePackage;
  cloudWatchLogs?: boolean;
  useECR?: boolean;
}
