# Gatling Private Locations & Private Packages Deployment with Infrastructure as Code (IaC)

## Overview

This repository includes configurations for deploying Gatling Private Locations and Private Packages across multiple cloud platforms. These scripts are designed to facilitate the setup of Gatling load testing solutions in a standardized, secure, and scalable manner. Gatling's Private Locations feature allows you to conduct load tests from specific geographical locations using privately hosted load generators. Meanwhile, Private Packages enable private storage of testing scripts and configurations.

## Why Use This Repository?

- **Standardization**: Ensures consistent configurations across different environments or projects, reducing errors and discrepancies.
- **Scalability**: Easily scales your testing infrastructure to meet the demands of large-scale performance testing scenarios.
- **Automation**: Reduces manual setup and configuration efforts, speeding up the deployment process and enabling rapid iteration.

Each directory includes:
- `main.tf` - The primary Terraform configuration file.
- `variables.tf` - Defines variables used in the configurations.
- `outputs.tf` - Specifies output variables that provide useful information after deployment.
- `modules` - Isolates the necessary components in order to build the Gatling Private Locations & Private Packages solution.
- `README.md` - Describes specific instructions and details for deploying on the respective cloud platform.