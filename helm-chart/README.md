# Helm chart for Kubernetes Private Locations and Private Packages

This Helm Chart sets up the Kubernetes resources for Gatling Enterprise's Private Locations and Private Packages deployment. There are 3 sets of values: `controlPlane`,
`privateLocations`, `privatePackage` with configurable parameters that can be used to customize the deployment.

## Prerequisites

- Gatling Enterprise [account](https://auth.gatling.io/auth/realms/gatling/protocol/openid-connect/auth?client_id=gatling-enterprise-cloud-public&response_type=code&scope=openid&redirect_uri=https%3A%2F%2Fcloud.gatling.io%2Fr%2Fgatling) with Private Locations enabled. To access this feature, please contact our [technical support](https://gatlingcorp.atlassian.net/servicedesk/customer/portal/8/group/12/create/59?summary=Private+Locations&description=Contact%20email%3A%20%3Cemail%3E%0A%0AHello%2C%20we%20would%20like%20to%20enable%20the%20private%20locations%20feature%20on%20our%20organization.).
- Gatling Enterprise control plane [token](https://docs.gatling.io/reference/install/cloud/private-locations/introduction/#token).
- Kubernetes Cluster: A running Kubernetes cluster (v1.19 or later) or [Minikube](https://minikube.sigs.k8s.io/docs/start/) installed locally.
- [Kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) command-line tool.
- [Helm](https://helm.sh/docs/intro/) 3+.

## Installation

1. Add the Gatling Helm Repository
```sh
helm repo add gatling "https://helm.gatling.io"
```

2. Update Helm Repositories
```sh
helm repo update
```

3. Search for Gatling charts. Optional: To list all versions of the Gatling charts, include the `--versions` flag:
```sh
helm search repo gatling
```

4. Review default configuration values & set your Gatling control plane token at `controlPlane.token` and other configuration values. Optional: To export specific chart version values, include the `--versions` flag:
```sh
helm show values gatling/enterprise-locations-packages > values.yaml
```

> [!IMPORTANT]
> For `privateLocations.job`, we're working at the job template spec level, rather than the job spec level. To get a closer look at the structure, refer to the example JSON job definition [here].(https://docs.gatling.io/reference/install/cloud/private-locations/kubernetes/configuration/#example-json-job-definition).

> [!TIP]
> When connecting to the cluster using HTTPS, if a custom truststore and/or keystore is needed, `KUBERNETES_TRUSTSTORE_FILE`, `KUBERNETES_TRUSTSTORE_PASSPHRASE` and/or `KUBERNETES_KEYSTORE_FILE`, `KUBERNETES_KEYSTORE_PASSPHRASE` environment variables should be set.

> [!TIP]
> The control plane and location configurations allow for the setup of a reverse proxy. To enable this, uncomment the extraContent section and its associated values in the configuration file for the control plane and/or location. Ensure the reverse proxy is configured to rewrite the Host header to `api.gatling.io` to ensure proper functionality.

5. Install the Gatling Enterprise Helm Chart. Optional: To install specific chart version, include the `--versions` flag:
```sh
helm install gatling-hybrid gatling/enterprise-locations-packages --namespace gatling --values <yaml-file/url> or --set key1=val1,key2=val2
```

### Activate Private Packages:

- In order to activate Private Packages feature, set `privatePackage.enabled` to `true`. Note: A persistent Volume Claim will be created automatically if type = 'filesystem'.

> [!IMPORTANT]
> By default, the Control Plane filesystem is selected as the storage option. Before activating a different solution, comment out the `privatePackage.persistentVolumeClaim` and the repository filesystem section.

## Uninstallation

1. Uninstall the Gatling Helm chart
```sh
helm uninstall gatling-hybrid -n gatling
```

2. Update Helm Repositories
```sh
helm repo remove gatling
```
