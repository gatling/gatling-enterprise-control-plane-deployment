#!/usr/bin/env node
import "source-map-support/register";
import { App } from "aws-cdk-lib";
import { ControlPlaneStack } from "../lib/control-plane";

const app = new App();
const stackName = "GatlingEnterprise-PrivateLocationPackage-Stack";

const privatePackage = {
  // Possible values available on interface PrivatePackage in lib/interfaces/common-interface.ts
  bucket: "private-package",
  path: "/"
};

const location = {
  // Possible values available on interface Location in lib/interfaces/common-interface.ts
  id: "prl_aws",
  description: "Private Location on AWS",
  region: "eu-west-3",
  subnets: ["subnet-a"],
  "security-groups": ["sg-id"],
  "instance-type": "c7i.xlarge",
  ami: {
    type: "certified"
  },
  engine: "classic",
  //"enterprise-cloud": {
    //url: "http://private-location-forward-proxy/gatling"
  //}
};

new ControlPlaneStack(app, stackName, {
  // Possible values available on interface ControlPlaneProps in lib/interfaces/control-plane-interface.ts
  token:
    "token",
  name: "gatling-pl",
  description: "My AWS control plane description",
  vpcId: "vpc-id",
  availabilityZones: ["eu-west-3a", "eu-west-3b", "eu-west-3c"],
  subnetIds: ["subnet-a", "subnet-b", "subnet-c"],
  securityGroupIds: ["sg-id"],
  image: "gatlingcorp/control-plane:latest",
  locations: [location],
  privatePackage,
  //cloudWatchLogs: true,
  //useECR: false
  //enterpriseCloud: {
    //url: "http://private-control-plane-forward-proxy/gatling"
  //}
});
