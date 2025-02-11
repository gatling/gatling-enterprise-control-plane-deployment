package com.gatlingenterprise.utils;

import com.gatlingenterprise.records.locationProps.EnterpriseCloud;
import com.gatlingenterprise.records.locationProps.Location;
import com.gatlingenterprise.records.locationProps.TagsFor;
import com.gatlingenterprise.records.packageProps.PrivatePackage;
import java.util.List;
import java.util.stream.Collectors;

public record ControlPlaneConfigGenerator(
    String desc,
    List<Location> locations,
    PrivatePackage privatePackage,
    EnterpriseCloud enterpriseCloud) {

  public String generateConfig() {
    return String.format(
        """
            {
                "control-plane": {
                    "enterprise-cloud": %s,
                    "token": ${?CONTROL_PLANE_TOKEN},
                    "description": "%s",
                    "locations": [%s],
                    "repository": %s
                }
            }
            """,
        formatEnterpriseCloud(enterpriseCloud), desc, formatLocations(), formatRepository());
  }

  private String formatEnterpriseCloud(EnterpriseCloud enterpriseCloud) {
    if (enterpriseCloud == null) {
      return "{}";
    }
    return String.format(
        """
        {
            "url": "%s",
        }
        """,
        enterpriseCloud.url());
  }

  private String formatTagsFor(TagsFor tagsFor) {
    if (tagsFor == null) {
      return "null";
    }
    return String.format(
        """
        {
            "instance": %s,
            "volume": %s,
            "network-interface": %s
        }
        """,
        tagsFor.instance() != null ? tagsFor.instance() : "{}",
        tagsFor.volume() != null ? tagsFor.volume() : "{}",
        tagsFor.networkInterface() != null ? tagsFor.networkInterface() : "{}");
  }

  private String formatLocations() {
    return locations.stream()
        .map(
            location ->
                String.format(
                    """
                {
                    "type": "aws",
                    "id": "%s",
                    "description": "%s",
                    "region": "%s",
                    "subnets": %s,
                    "security-groups": %s,
                    "instance-type": "%s",
                    "spot": %s,
                    "ami": {
                        "type": "%s",
                        "java": "%s",
                        "image": %s
                    },
                    "engine": "%s",
                    "elasticIps": %s,
                    "tags": %s,
                    "tags-for": %s,
                    "profile-name": "%s",
                    "iam-instance-profile": "%s",
                    "system-properties": %s,
                    "java-home": "%s",
                    "jvm-options": %s,
                    "enterprise-cloud": %s
                }
                """,
                    location.id(),
                    location.desc(),
                    location.region(),
                    formatList(location.subnets()),
                    formatList(location.securityGroups()),
                    location.instanceType(),
                    location.spot(),
                    location.ami().type(),
                    location.ami().java() != null ? location.ami().java() : "null",
                    location.ami().image() != null
                        ? String.format("\"%s\"", location.ami().image())
                        : "null",
                    location.engine(),
                    formatList(location.elasticIps()),
                    location.tags(),
                    formatTagsFor(location.tagsFor()),
                    location.profileName(),
                    location.iamInstanceProfile(),
                    location.systemProperties(),
                    location.javaHome(),
                    location.jvmOptions(),
                    formatEnterpriseCloud(location.enterpriseCloud())))
        .collect(Collectors.joining(",\n"));
  }

  private String formatRepository() {
    if (privatePackage == null) {
      return "{}";
    }
    return String.format(
        """
            {
                "type": "aws",
                "bucket": "%s",
                "path": "%s",
                "upload": %s,
                "server": %s
            }
            """,
        privatePackage.bucket(),
        privatePackage.path(),
        privatePackage.upload() != null
            ? String.format(
                """
                    {
                        "directory": "%s"
                    }
                    """,
                privatePackage.upload().directory() != null
                    ? privatePackage.upload().directory()
                    : "/tmp")
            : "null",
        privatePackage.server() != null
            ? String.format(
                """
                    {
                        "port": %s,
                        "bindAddress": "%s",
                        "certificate": %s
                    }
                    """,
                privatePackage.server().port() != null ? privatePackage.server().port() : 8080,
                privatePackage.server().bindAddress() != null
                    ? privatePackage.server().bindAddress()
                    : "0.0.0.0",
                privatePackage.server().certificate() != null
                    ? String.format(
                        """
                            {
                                "path": "%s",
                                "password": %s
                            }
                            """,
                        privatePackage.server().certificate().path(),
                        privatePackage.server().certificate().password() != null
                            ? String.format(
                                "\"%s\"", privatePackage.server().certificate().password())
                            : "null")
                    : "null")
            : "null");
  }

  private String formatList(List<String> list) {
    return list.stream()
        .map(item -> String.format("\"%s\"", item))
        .collect(Collectors.joining(", ", "[", "]"));
  }
}
