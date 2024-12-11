package com.gatlingenterprise.records.controlPlaneProps;

import com.gatlingenterprise.records.packageProps.PrivatePackage;
import software.amazon.awscdk.NestedStackProps;

public record IAMStackProps(
    String name, PrivatePackage privatePackage, boolean cloudWatchLogs, boolean useECR)
    implements NestedStackProps {}
