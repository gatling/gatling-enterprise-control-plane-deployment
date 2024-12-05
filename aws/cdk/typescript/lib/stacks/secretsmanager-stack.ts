import { NestedStack, SecretValue } from "aws-cdk-lib";
import { Secret } from "aws-cdk-lib/aws-secretsmanager";
import { Construct } from "constructs";
import { SecretsManagerStackProps } from "../interfaces/secretsmanager-interface";

export class SecretsManagerStack extends NestedStack {
  public readonly token: Secret;

  constructor(scope: Construct, id: string, props: SecretsManagerStackProps) {
    super(scope, id, props);

    const { secretName, description, secretValue } = props;

    this.token = new Secret(this, "ControlPlaneSecret", {
      description,
      secretName,
      secretStringValue: SecretValue.unsafePlainText(secretValue)
    });
  }
}
