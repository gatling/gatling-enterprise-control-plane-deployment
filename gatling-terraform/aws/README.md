# Gatling Private Locations & Private Packages Deployment on AWS with Terraform

This repository contains Terraform scripts for deploying Gatling Private Locations and Private Packages along with necessary AWS resources. It is designed to facilitate the setup of Gatling load testing solutions in a standardized and secure manner.

## Prerequisites

Before you begin, ensure you have the following:
- An AWS account with necessary permissions to create the resources outlined in the Terraform scripts.
- Terraform installed on your local machine or CI/CD environment.

## Important Note

This Terraform configuration does not create any VPCs, subnets, routers, or security groups. It also does not modify any outbound rules. These network configurations need to be managed and configured manually or integrated from existing resources within your AWS environment.

## Clone the repository

   ```bash
   git clone https://github.com/gatling/gatling-enterprise-control-plane-deployment.git
   cd aws/terraform
   ```

## Configure the Solution:

1. **Open the `variables.tf`** to set up your specific deployment settings.
2. **Specify the solution name** which will be used as a prefix for the resources created by setting `cp_name`.
3. **Enter the control plane configuration** either through the CLI prompts when running Terraform or by directly setting it in the `variables.tf`.
4. **Define the Private Locations configuration** in the `locations` variable within your Terraform variables file. Make sure to provide all required details such as region, instance type, and AMI details.

## Deploy the Solution:

1. **Initiliaze Terraform `terraform init`**
2. **Apply the configuration `terraform apply`**

## Manage the Solution:

1. **To update your deployment, modify the Terraform configuration files as needed and rerun terraform apply. `terraform apply`**
2. **To tear down your infrastructure and stop all services, execute: `terraform destroy`**

## Activate Private Locations

To activate Private Locations, set the `pp_flag` to `true` in your configuration file. This action will enable the deployment of related resources such as the S3 permissions and the Application Load Balancer and other necessary AWS services.
