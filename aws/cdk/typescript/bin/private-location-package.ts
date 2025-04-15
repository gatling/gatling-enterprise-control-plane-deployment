#!/usr/bin/env node
import "source-map-support/register";
import { App } from "aws-cdk-lib";
import { ControlPlaneStack } from "../lib/control-plane";

const app = new App();
const stackName = "GatlingEnterprise-PrivateLocationPackage-Stack";

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

const location = {
  // Possible values available on interface Location in lib/interfaces/common-interface.ts
  id: "prl_aws",
  description: "Private Location on AWS",
  region: "‹Region>",
  subnets: ["<SubnetId>"],
  "security-groups": ["<SecurityGroupId>"],
  "instance-type": "c7i.xlarge",
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
  privatePackage,
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
