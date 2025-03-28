# Gatling Enterprise Private Locations & Packages CloudFormation Template

This CloudFormation template sets up Gatling Enterprise Private Locations infrastructure on AWS. It contains nested stacks for the "Location" and "Control Plane" components, which provide network configurations and runtime environment settings for Gatling's Private Locations.

> [!WARNING]
> These scripts are here to help you bootstrapping your installation.
> They are likely to frequently change in an incompatible fashion.
> Feel free to fork them and adapt them to your needs

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

The Location stack defines the private locations where load generators will operate.

```sh
Location:
  Type: AWS::CloudFormation::Stack
  Properties:
    TemplateURL: !Sub ${BaseTemplateURL}/location/template.yaml
    Parameters:
      Id: "prl_aws"
      Region: "eu-west-3"
      SubnetIDs: "[\"subnet-a\",\"subnet-b\"]"
      SecurityGroupIDs: "[\"sg-id\"]"
      #Engine: "classic"
      #InstanceType: "c7i.xlarge"
```

- `Id`: Identifier for the location. Default is `"prl_aws"`.
- `Description`: Description of the location.
- `Region`: AWS region for deployment, specified as `"eu-west-1"`.
- `SubnetIDs`: string JSON array of subnet IDs (e.g., `"[\"subnet-a\",\"subnet-b\"]"`).
- `SecurityGroupIDs`: string JSON array of security group IDs to control network access (e.g., `"[\"sg-id\"]"`).
- `ElasticIPs`: string JSON array of elastic IPs assigned to your location.
- `InstanceType`: Instance type of the location.
- `Spot`: Flag to enable spot instances.
- `AMItype`: AMI type of the location.
- `Engine`: Engine of the location determining the compatible package formats (JavaScript or JVM).
- `JavaVersion`: Java version of the location.
- `ProfileName`: Profile name to be assigned to the location.
- `IAMInstanceProfile`: IAM instance profile to be assigned to the location.
- `Tags`: Tags to be assigned to the Location.
- `TagsFor`: Tags to be assigned to the resources of the location.
- `SystemProperties`: System properties to be assigned on the location.
- `JvmOptions`: System properties to be assigned to the location.
- `JavaHome`: Overwrite JAVA_HOME definition.
- `JvmOptions`: string JSON array to assign JvmOptions to your location.

#### Control Plane Stack

The Control Plane stack configures networking, security, and storage for Gatling's control plane.

```sh
ControlPlane:
  Type: AWS::CloudFormation::Stack
  Properties:
    TemplateURL: !Sub "${BaseTemplateURL}/control-plane/template.yaml"
    Parameters:
      BaseTemplateURL: !Ref BaseTemplateURL
      Name: "name"
      TokenSecretARN: "token-secret-arn"
      SubnetIDs: "subnet-a,subnet-b"
      SecurityGroupIDs: "sg-id"
      Locations: !Sub "${Location.Outputs.Conf}"
      #CloudWatchLogs: "true"
      #UseECR: "false"
```
- `BaseTemplateURL` (required): The root URL for locating the CloudFormation templates. (Use Gatling's official distribution: https://cloudformation-enterprise-templates.s3.eu-west-3.amazonaws.com)
- `Name` (required): The name of the control plane.
- `Description`: Description of the control plane.
- `TokenSecretARN` (required): AWS Secrets Manager Plaintext secret ARN of the stored control plane token.
- `SubnetIDs` (required): List of subnet IDs where the resources will be deployed.
- `SecurityGroupIDs` (required): List of security group IDs to be used.
- `Image`: Image of the control plane.
- `Command`: The command to run in the control-plane container.
- `Locations` (required): The list of location module(s).
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
