# Gatling Enterprise Private Locations & Packages AWS CDK (TypeScript)

![Gatling-enterprise-logo-RVB](https://github.com/user-attachments/assets/6cd75464-0173-4578-9ad1-b2481cc9b36b)

This CDK application sets up Gatling Enterprise Private Locations and Packages infrastructure on AWS. It includes constructs for the `Control Plane`, `Location`, and `Private Package` with network configurations and runtime environment settings for Gatling's Private Locations & Packages.

![aws-diagram](https://github.com/user-attachments/assets/9bcabed2-db71-4829-b768-ac6d7124010e)

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
  name: "<Name>",
  description: "My AWS control plane description",
  tokenSecretArn: "<TokenSecretARN>",
  vpcId: "<VPCId>",
  availabilityZones: ["<AZ>"],
  subnets: ["<SubnetId>"],
  securityGroups: ["<SecurityGroupId>"],
  locations: [location],
  // task: {
  //   cpu: 1024,
  //   memory: 3072,
  //   init: {
  //     image: "busybox",
  //   },
  //   image: "gatlingcorp/control-plane:latest",
  //   command: [],
  //   secrets: {},
  //   environment: {},
  //   cloudwatchLogs: true,
  //   ecr: false,
  // },
  // enterpriseCloud: {
  //   // Setup the proxy configuration for the control plane
  //   // Reference: https://docs.gatling.io/reference/install/cloud/private-locations/network/#configuring-a-proxy
  // },
});
```

#### Location

The Location object defines the private locations where load generators will operate.

```typescript
const location = {
  // Possible values available on interface Location in lib/interfaces/common-interface.ts
  id: "prl_aws",
  description: "Private Location on AWS",
  region: "‹Region>",
  subnets: ["<SubnetId>"],
  "security-groups": ["<SecurityGroupId>"],
  "instance-type": "c7i.xlarge",
  // engine: "classic",
  ami: {
    type: "certified",
    //   java: "latest",
    //   id: "ami-00000000000000000",
  },
  // engine: "classic",
  // spot: false,
  // "auto-associate-public-ipv4": true,
  // "elastic-ips": ["203.0.113.3"],
  // "profile-name": "profile-name",
  // "iam-instance-profile": "iam-instance-profile",
  // tags: {},
  // "tags-for": {
  //   instance: {},
  //   volume: {},
  //   "network-interface": {},
  // },
  // "system-properties": {},
  // "java-home": "/usr/lib/jvm/zulu",
  // "jvm-options": [],
  // "enterprise-cloud": {
  //   // Setup the proxy configuration for the private location
  //   // Reference: https://docs.gatling.io/reference/install/cloud/private-locations/network/#configuring-a-proxy
  // },
};
```

#### Private Package (Optional)

The Private Package object defines a secure S3 bucket where private packages are stored.

```typescript
const privatePackage = {
  // Possible values available on interface PrivatePackage in lib/interfaces/common-interface.ts
  bucket: "private-package",
  // path: "",
  // upload: {
  //   directory: "/tmp",
  // },
  // server: {
  //   port: 8080,
  //   bindAddress: "0.0.0.0",
  //   certificate: {
  //     path: "/path/to/certificate.p12",
  //     password: "password",
  //   },
  // }
};
```

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
