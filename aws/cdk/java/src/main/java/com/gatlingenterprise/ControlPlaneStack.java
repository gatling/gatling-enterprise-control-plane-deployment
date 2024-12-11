package com.gatlingenterprise;

import static com.gatlingenterprise.stacks.IAMstack.ecsTaskRoleArn;
import static com.gatlingenterprise.stacks.SecretsManagerStack.secretToken;

import com.gatlingenterprise.records.controlPlaneProps.ControlPlaneProps;
import com.gatlingenterprise.records.controlPlaneProps.ECSstackProps;
import com.gatlingenterprise.records.controlPlaneProps.IAMStackProps;
import com.gatlingenterprise.records.controlPlaneProps.SecretsManagerStackProps;
import com.gatlingenterprise.records.locationProps.EnterpriseCloud;
import com.gatlingenterprise.stacks.ECSstack;
import com.gatlingenterprise.stacks.IAMstack;
import com.gatlingenterprise.stacks.SecretsManagerStack;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import software.amazon.awscdk.Stack;
import software.amazon.awscdk.services.secretsmanager.ISecret;
import software.constructs.Construct;

public class ControlPlaneStack extends Stack {
  public ControlPlaneStack(Construct scope, String id, ControlPlaneProps props) {
    super(scope, id, props);

    String vpcId = props.vpcId();
    List<String> availabilityZones = props.availabilityZones();
    List<String> subnetIds = props.subnetIds();
    List<String> securityGroupIds = props.securityGroupIds();
    String token = props.token();
    String tokenSecretName =
        props.tokenSecretName() != null
            ? props.tokenSecretName()
            : "GatlingEnterprise/ControlPlane/Token";
    String name = props.name();
    String desc = props.desc();
    String image = props.image();
    List<String> command = props.command() != null ? props.command() : new ArrayList<>();
    Map<String, String> environment =
        props.environment() != null ? props.environment() : new HashMap<>();
    Map<String, ISecret> secrets =
        props.secrets() != null ? new HashMap<>(props.secrets()) : new HashMap<>();
    var locations = props.locations();
    var privatePackage = props.privatePackage();
    boolean cloudWatchLogs = props.cloudWatchLogs() != null ? props.cloudWatchLogs() : true;
    boolean useECR = props.useECR() != null ? props.useECR() : false;
    EnterpriseCloud enterpriseCloud = props.enterpriseCloud();

    new IAMstack(this, "iam", new IAMStackProps(name, privatePackage, cloudWatchLogs, useECR));

    new SecretsManagerStack(
        this,
        "sm",
        new SecretsManagerStackProps(
            "Token for Gatling Enterprise control plane.", tokenSecretName, token));

    secrets.put("CONTROL_PLANE_TOKEN", secretToken);

    new ECSstack(
        this,
        "ecs",
        new ECSstackProps(
            vpcId,
            availabilityZones,
            subnetIds,
            securityGroupIds,
            ecsTaskRoleArn,
            name,
            desc,
            image,
            command,
            environment,
            secrets,
            locations,
            privatePackage,
            cloudWatchLogs,
            enterpriseCloud));
  }
}
