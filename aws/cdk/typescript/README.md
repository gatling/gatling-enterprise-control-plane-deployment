# Gatling Enterprise Private Locations & Packages AWS CDK (TypeScript)

This CDK application sets up Gatling Enterprise Private Locations and Packages infrastructure on AWS. It includes constructs for the `Control Plane`, `Location`, and `Private Package` with network configurations and runtime environment settings for Gatling's Private Locations & Packages.

## Prerequisites

Before deploying, ensure you have:
- A [Gatling Enterprise account](https://auth.gatling.io) with Private Locations enabled.
- A control plane [token](https://docs.gatling.io/reference/install/cloud/private-locations/introduction/#token) stored in AWS Secrets Manager as a plaintext secret.
- Proper AWS credentials configured.

## Application Structure

The main components in this CDK application are:
1. **Control Plane**: Manages configurations, networking, and security for Gatling's control plane.
2. **Location**: Specifies the private location configuration for Gatling load generators.
3. **Private Package**: Specifies the private location configuration for Gatling's control plane.

> [!IMPORTANT]
> By default the CDK app deploys `private-location.ts`. To execute and deploy `private-location-package.ts`, please change the `app` value in `cdk.json` from `npx ts-node --prefer-ts-exts bin/private-location.ts` to `npx ts-node --prefer-ts-exts bin/private-location-package.ts`.

### Objects Overview

#### Control Plane

The Control Plane stack configures networking, security, and storage for Gatling's control plane.

```typescript
new ControlPlaneStack(app, stackName, {
  // Possible values available on interface ControlPlaneProps in lib/interfaces/control-plane-interface.ts
  tokenSecretARN: "token-secret-ARN",
  name: "gatling-pl",
  description: "My AWS control plane description",
  vpcId: "vpc-id",
  availabilityZones: ["eu-west-3a", "eu-west-3b", "eu-west-3c"],
  subnetIds: ["subnet-a", "subnet-b", "subnet-c"],
  securityGroupIds: ["sg-id"],
  image: "gatlingcorp/control-plane:latest",
  locations: [location]
  //privatePackage,
  //cloudWatchLogs: true,
  //useECR: false,
  //enterpriseCloud: {
    //url: "http://private-control-plane-forward-proxy/gatling"
  //}
});
```

- tokenSecretARN (required): AWS Secrets Manager Plaintext secret ARN of the stored control plane token.
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

```typescript
const location = {
  // Possible values available on interface Location in lib/interfaces/common-interface.ts
  id: "prl_aws",
  description: "Private Location on AWS",
  region: "eu-west-3",
  subnetIds: ["subnet-a", "subnet-b", "subnet-c"],
  "security-groups": ["sg-id"],
  "instance-type": "c7i.xlarge",
  ami: {
    type: "certified"
  },
  engine: "classic"
  //enterprise-cloud: {
    //url: http://private-location-forward-proxy/gatling
  //}
};
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

```typescript
const privatePackage = {
  // Possible values available on interface PrivatePackage in lib/interfaces/common-interface.ts
  bucket: "private-package",
  path: "/"
};
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
npm install
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
