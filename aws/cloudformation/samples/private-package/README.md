# Gatling Enterprise Private Locations & Packages CloudFormation Template

This CloudFormation template sets up Gatling Enterprise Private Locations and Packages infrastructure on AWS. It contains nested stacks for the "Private Package", "Location" and "Control Plane" components, which provide network configurations and runtime environment settings for Gatling's Private Locations.

## Prerequisites

Before deploying, ensure you have:
- A [Gatling Enterprise account](https://auth.gatling.io) with Private Locations enabled.
- A control plane [token](https://docs.gatling.io/reference/install/cloud/private-locations/introduction/#token).
- Proper AWS credentials configured.

## Template Structure

The main components in this CloudFormation template are:
1. **Location**: Specifies the private location for Gatling load generators.
2. **Control Plane**: Manages configurations, networking, and security for Gatling's control plane.

### Parameters

- **BaseTemplateURL** (required): The root URL for locating the CloudFormation templates. (Use Gatling's official distribution: https://cloudformation-enterprise-templates.s3.eu-west-3.amazonaws.com)

### Resources

#### Location Stack

The Private Package stack defines a secure S3 bucket where private packages are stored.

```sh
PrivatePackage:
  Type: AWS::CloudFormation::Stack
  Properties:
    TemplateURL: !Sub "${BaseTemplateURL}/templates/private-package/template.yaml"
    Parameters:
      Bucket: "bucket"
```

- `Bucket` (required): Name of the S3 bucket used to store private packages.
- `Path`: The path within the S3 bucket.
- `Port`: The server port. (default: 8080)
- `BindAddress`: The server bind address. (default: 0.0.0.0)
- `CertPath`: The path to the certificate file. Leave empty if not provided.
- `CertPassword`: The password for the certificate. Leave empty if not provided.

#### Location Stack

The Location stack defines the private locations where load generators will operate.

```sh
Location:
  Type: AWS::CloudFormation::Stack
  Properties:
  TemplateURL: !Sub "${BaseTemplateURL}/templates/location/template.yaml"
  Parameters:
    Id: "prl_aws"
    Region: "eu-west-3"
    SubnetIDs: "subnet-a,subnet-b"
    SecurityGroupIDs: "sg-id"
    #Engine: "classic"
    #InstanceType: "c7i.xlarge"
```

- `Id`: Identifier for the location. Default is `"prl_aws"`.
- `Region`: AWS region for deployment, specified as `"eu-west-1"`.
- `SubnetIDs`: Comma-separated list of subnet IDs (e.g., `"subnet-a,subnet-b"`).
- `SecurityGroupIDs`: Security group ID to control network access (e.g., `"sg-id"`).
- `Description` (optional): Description of the location.
- `AMItype` (optional): Description of the location.
- `ElasticIPs`: Assign elastic IPs to your Locations.
- `Description`: Description of the location.
- `AMItype`: AMI type of the location.
- `JavaVersion`: Java version of the location.
- `Spot`: Flag to enable spot instances.
- `ProfileName`: Profile name to be assigned to the Location.
- `IAMInstanceProfile`: IAM instance profile to be assigned to the Location.
- `Tags`: Tags to be assigned to the Location.
- `TagsFor`: Tags to be assigned to the resources of the Location.
- `SystemProperties`: System properties to be assigned on the Location.
- `JvmOptions`: System properties to be assigned to the Location.
- `JavaHome`: Overwrite JAVA_HOME definition.
- `JvmOptions`: Overwrite JAVA_HOME definition.

#### Control Plane Stack

The Control Plane stack configures networking, security, and storage for Gatling's control plane.

```sh
ControlPlane:
  Type: AWS::CloudFormation::Stack
  Properties:
    TemplateURL: !Sub "${BaseTemplateURL}/templates/control-plane/template.yaml"
    Parameters:
    Name: "name"
    Token: "token"
    SubnetIDs: "subnet-a,subnet-b"
    SecurityGroupIDs: "sg-id"
    ConfS3Bucket: "control-plane-conf"
    Locations: !Sub "${Location.Outputs.Conf}"
    PrivatePackage: !GetAtt PrivatePackage.Outputs.Conf
    #CloudWatchLogs: "true"
    #UseECR: "false"
```

- `Name` (required): The name of the control plane.
- `Token` (required): The control plane token for authentication.
- `SubnetIDs` (required): List of subnet IDs where the resources will be deployed.
- `SecurityGroupIDs` (required): List of security group IDs to be used.
- `ConfS3Bucket` (required): The name of the S3 bucket for configuration.
- `Locations` (required): The list of location module(s).
- `PrivatePackage` (required): The name of the private package stack for configuration.
- `Image`: Image of the control plane.
- `Description`: Description of the control plane.
- `ObjectKey`: The key of the configuration object in the S3 bucket.
- `Image`: The Docker image for the control-plane container.
- `Command`: The command to run in the control-plane container.
- `CloudWatchLogs`: Indicates if CloudWatch Logs are enabled.
- `UseECR`: Indicates if ECR IAM permissions should be created.


## Deployment Instructions

1. Set up the **BaseTemplateURL** parameter to point to the root URL where your templates are stored.
3. Adjust your template with your configuration.
4. Deploy the template using the AWS CloudFormation console or CLI.

```sh
aws cloudformation deploy --stack-name Gatling-Enterprise-PrivateLocations \
  --template-file file://path_to_template.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides BaseTemplateURL=https://cloudformation-enterprise-templates.s3.eu-west-3.amazonaws.com
```
