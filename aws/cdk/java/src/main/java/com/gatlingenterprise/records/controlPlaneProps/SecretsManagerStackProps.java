package com.gatlingenterprise.records.controlPlaneProps;

import software.amazon.awscdk.NestedStackProps;

public record SecretsManagerStackProps(String desc, String secretName, String secretValue)
    implements NestedStackProps {}
