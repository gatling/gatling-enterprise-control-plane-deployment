package com.gatlingenterprise.records.controlPlaneProps;

import com.gatlingenterprise.records.locationProps.EnterpriseCloud;
import com.gatlingenterprise.records.locationProps.Location;
import com.gatlingenterprise.records.packageProps.PrivatePackage;
import java.util.List;
import java.util.Map;
import software.amazon.awscdk.StackProps;
import software.amazon.awscdk.services.secretsmanager.ISecret;

public record ControlPlaneProps(
    String vpcId,
    List<String> availabilityZones,
    List<String> subnetIds,
    List<String> securityGroupIds,
    String token,
    String tokenSecretName,
    String name,
    String desc,
    String image,
    List<String> command,
    Map<String, String> environment,
    Map<String, ISecret> secrets,
    List<Location> locations,
    PrivatePackage privatePackage,
    Boolean cloudWatchLogs,
    Boolean useECR,
    EnterpriseCloud enterpriseCloud)
    implements StackProps {}
