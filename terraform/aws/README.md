# Gatling Private Locations & Private Packages Deployment on AWS with Terraform

This repository contains Terraform modules for deploying Gatling Control Plane, Private Location and Private Package along with necessary AWS resources. It is designed to facilitate the setup of Gatling load testing solutions in a standardized and secure manner.

## Prerequisites

Before you begin, ensure you have the following:
- An AWS account with necessary permissions to create the resources outlined in the Terraform scripts.
- Terraform installed on your local machine or CI/CD environment.

## Important Note

These Terraform configurations do not create any VPCs, subnets, routers, security groups or S3 Buckets. It also does not modify any outbound rules. These network configurations need to be managed and configured manually or integrated from existing resources within your AWS environment.


## Structure:

The repository is organized into the following modules:
- `control-plane`: Deploys the control plane resources.
- `location`: Creates the location-specific configuration.
- `private-package`: Manages the private package configuration.