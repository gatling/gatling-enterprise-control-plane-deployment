package com.gatlingenterprise.stacks;

import com.gatlingenterprise.records.controlPlaneProps.SecretsManagerStackProps;
import software.amazon.awscdk.NestedStack;
import software.amazon.awscdk.SecretValue;
import software.amazon.awscdk.services.secretsmanager.Secret;
import software.constructs.Construct;

public class SecretsManagerStack extends NestedStack {
  public static Secret secretToken;

  public SecretsManagerStack(Construct scope, String id, SecretsManagerStackProps props) {
    super(scope, id, props);

    String secretName = props.secretName();
    String desc = props.desc();
    String secretValue = props.secretValue();

    secretToken =
        Secret.Builder.create(this, "ControlPlaneSecret")
            .description(desc)
            .secretName(secretName)
            .secretStringValue(SecretValue.unsafePlainText(secretValue))
            .build();
  }
}
