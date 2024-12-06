import { StackProps } from "aws-cdk-lib";

export interface SecretsManagerStackProps extends StackProps {
  description: string;
  secretName: string;
  secretValue: string;
}
