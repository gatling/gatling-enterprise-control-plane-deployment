package com.gatlingenterprise;

import com.gatlingenterprise.records.controlPlaneProps.ControlPlaneProps;
import com.gatlingenterprise.records.locationProps.AMI;
import com.gatlingenterprise.records.locationProps.EnterpriseCloud;
import com.gatlingenterprise.records.locationProps.Location;
import com.gatlingenterprise.records.locationProps.TagsFor;
import java.util.List;
import java.util.Map;
import software.amazon.awscdk.App;

public class PrivateLocation {
  public static void main(final String[] args) {
    App app = new App();

    String stackName = "GatlingEnterprise-PrivateLocation-Stack";

    Location location =
        new Location(
            "prl_aws", // id
            "Private Location on AWS", // desc
            "eu-west-1", // region
            List.of("subnet-1"), // subnets
            List.of("sg-id"), // securityGroups
            "c7i.xlarge", // instanceType
            false, // spot
            new AMI("certified", "latest", null), // ami
            "classic", // engine
            List.of(), // elasticIps
            Map.of(), // tags
            new TagsFor(null, null, null), // tagsFor (set to null if absent)
            "", // profileName
            "", // iamInstanceProfile
            Map.of(), // systemProperties
            "/usr/lib/jvm/zulu", // javaHome
            List.of(), // jvmOptions
            new EnterpriseCloud("https://api.gatling.io") // Location forward proxy url
            );

    new ControlPlaneStack(
        app,
        stackName,
        new ControlPlaneProps(
            "vpc-id", // vpcId
            List.of("eu-west-1a", "eu-west-1b", "eu-west-1c"), // availabilityZones
            List.of("subnet-1", "subnet-2", "subnet-3"), // subnetIds
            List.of("sg-id"), // securityGroupIds
            "token", // token
            "GatlingEnterprise/ControlPlane/Token", // tokenSecretName
            "gatling-pl", // name
            "My AWS control plane description", // desc
            "gatlingcorp/control-plane:latest", // image
            List.of(), // command
            Map.of(), // environment
            Map.of(), // secrets
            List.of(location), // locations
            null, // privatePackage
            true, // cloudWatchLogs
            false, // useECR
            new EnterpriseCloud("https://api.gatling.io") // Control plane forward proxy url
            ));

    app.synth();
  }
}
