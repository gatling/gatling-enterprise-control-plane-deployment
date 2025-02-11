# Gatling Enterprise Private Locations & Packages AWS CDK (Java)

This CDK application sets up Gatling Enterprise Private Locations and Packages infrastructure on AWS. It includes constructs for the `Control Plane`, `Location`, and `Private Package` with network configurations and runtime environment settings for Gatling's Private Locations & Packages.

## Prerequisites

Before deploying, ensure you have:

- A [Gatling Enterprise account](https://auth.gatling.io) with Private Locations enabled.
- A control plane [token](https://docs.gatling.io/reference/install/cloud/private-locations/introduction/#token).
- Proper AWS credentials configured.
- A Java AWS CDK project set up (e.g., a Maven project with the CDK dependencies).

## Application Structure

The main components in this CDK application are:

1. `Control Plane`: Manages configurations, networking, and security for Gatling's control plane.
2. `Location`: Specifies the private location configuration for Gatling load generators.
3. `Private Package`: Specifies the private package configuration for Gatling's control plane.

> [!IMPORTANT]  
> By default, the original Java CDK app deploys the `PrivateLocation.java` class. In a Java CDK setup, the `mainClass` in the MojoHaus Maven Plugin configuration in the `pom.xml` file defines which Java class to synthesize and deploy. Ensure the correct stack class is instantiated in your `mainClass` before running `cdk deploy`.

### Objects Overview

#### Control Plane

The Control Plane stack configures networking, security, and storage for Gatling's control plane.

```java
new ControlPlaneStack(
    app,
    stackName,
    new ControlPlaneProps(
        "vpc-id", // vpcId
        List.of("eu-west-3a", "eu-west-3b", "eu-west-3c"), // availabilityZones
        List.of(
            "subnet-1",
            "subnet-2",
            "subnet-3"), // subnetIds
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
        privatePackage, // privatePackage
        true, // cloudWatchLogs
        false, // useECR
        new EnterpriseCloud("https://api.gatling.io") // Control plane forward proxy url
        ));
```

- token (required): The control plane token for authentication.
- name (required): The name of the control plane.
- description: Description of the control plane.
- vpcId (required): VPC ID where the resources will be deployed.
- subnetIds (required): List of subnet IDs where the resources will be deployed.
- securityGroupIds (required): List of security group IDs to be used.
- image: Image of the control plane.
- command: The command to run in the control-plane container.
- locations (required): The list of location module(s).
- privatePackage: The name of the private package object for configuration.
- cloudWatchLogs: Indicates if CloudWatch Logs are enabled.
- useECR: Indicates if ECR IAM permissions should be created.
- enterpriseCloud.url: Set up a forward proxy for the control plane.

#### Location

The Location object defines the private locations where load generators will operate.

```java
Location location =
    new Location(
        "prl_aws", // id
        "Private Location on AWS", // desc
        "eu-west-3", // region
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
```

- id: Identifier for the location. Default is "prl_aws".
- description: Description of the location.
- region: AWS region for deployment, specified as "eu-west-1".
- subnetIds: string JSON array of subnet IDs (e.g., "[\"subnet-a\",\"subnet-b\"]").
- security-groups: string JSON array of security group IDs to control network access (e.g., "[\"sg-id\"]").
- elastic-ips: string JSON array of elastic IPs assigned to your location.
- instance-type: Instance type of the location.
- spot: Flag to enable spot instances.
- ami.type: AMI type of the location.
- ami.java: Java version of the location.
- engine: Engine of the location determining the compatible package formats (JavaScript or JVM).
- profile-name: Profile name to be assigned to the location.
- iam-instance-profile: IAM instance profile to be assigned to the location.
- tags: Tags to be assigned to the Location.
- tags-for: Tags to be assigned to the resources of the location.
- system-properties: System properties to be assigned on the location.
- java-home: Overwrite JAVA_HOME definition.
- jvm-options: string JSON array to assign JvmOptions to your location.
- enterprise-cloud.url: Set up a forward proxy for the location.

#### Private Package (Optional)

The Private Package object defines a secure S3 bucket where private packages are stored.

```java
PrivatePackage privatePackage =
    new PrivatePackage("bucket-name", "/", new Upload(null), new Server(null, null, null));
```

- bucket (required): Name of the S3 bucket used to store private packages.
- path: The path within the S3 bucket.
- upload.directory: Temporary upload directory.
- server.port: The server port. (default: 8080)
- server.bindAddress: The server bind address. (default: 0.0.0.0)
- server.certificate.path: The path to the certificate file. Leave empty if not provided.
- server.certificate.password: The password for the certificate. Leave empty if not provided.

## Deployment Instructions

1. Install dependencies and bootstrap your environment.
```sh
mvn clean package
cdk bootstrap
```

2. Deploy the stacks.
```sh
cdk deploy --all
```

## Cleanup

To delete all resources, use the `cdk destroy` command.
```sh
cdk destroy --all
```
