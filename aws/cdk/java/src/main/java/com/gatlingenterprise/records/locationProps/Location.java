package com.gatlingenterprise.records.locationProps;

import java.util.List;
import java.util.Map;

public record Location(
    String id,
    String desc,
    String region,
    List<String> subnets,
    List<String> securityGroups,
    String instanceType,
    Boolean spot, // Optional
    AMI ami, // Optional
    String engine,
    List<String> elasticIps, // Optional
    Map<String, String> tags, // Optional
    TagsFor tagsFor, // Optional
    String profileName, // Optional
    String iamInstanceProfile, // Optional
    Map<String, String> systemProperties, // Optional
    String javaHome, // Optional
    List<String> jvmOptions, // Optional
    EnterpriseCloud enterpriseCloud // Optional
    ) {}
