package com.gatlingenterprise.records.controlPlaneProps;

import com.gatlingenterprise.records.locationProps.EnterpriseCloud;
import com.gatlingenterprise.records.locationProps.Location;
import com.gatlingenterprise.records.packageProps.PrivatePackage;
import java.util.List;
import java.util.Map;
import software.amazon.awscdk.NestedStackProps;
import software.amazon.awscdk.services.secretsmanager.ISecret;

public record ECSstackProps(
    String vpcId,
    List<String> availabilityZones,
    List<String> subnetIds,
    List<String> securityGroupIds,
    String ecsTaskRoleArn,
    String name,
    String desc,
    String image,
    List<String> command,
    Map<String, String> environment,
    Map<String, ISecret> secrets,
    List<Location> locations,
    PrivatePackage privatePackage,
    Boolean cloudWatchLogs,
    EnterpriseCloud enterpriseCloud)
    implements NestedStackProps {}
