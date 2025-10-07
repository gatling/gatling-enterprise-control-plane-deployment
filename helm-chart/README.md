# Helm Chart for Gatling Enterprise Private Locations & Private Package

[<picture><source media="(prefers-color-scheme: dark)" srcset="https://docs.gatling.io/images/logo-gatling.svg"><img src="https://docs.gatling.io/images/logo-gatling-noir.svg" alt="Gatling" width="50%"></picture>](https://gatling.io)

This Helm chart deploys Gatling Enterprise Private Locations and Private Packages to your Kubernetes cluster. It provides three main configuration sections—`controlPlane`, `privateLocations`, and `privatePackage`—to customize your setup.

<img width="2456" height="2096" alt="kubernetes-diagram" src="https://github.com/user-attachments/assets/e41401f9-cd1d-42fc-9bd0-d8c2bb71be53" />

## Prerequisites

- Gatling Enterprise [account](https://auth.gatling.io/auth/realms/gatling/protocol/openid-connect/auth?client_id=gatling-enterprise-cloud-public&response_type=code&scope=openid&redirect_uri=https%3A%2F%2Fcloud.gatling.io%2Fr%2Fgatling) with Private Locations enabled. If you do not have this feature, contact [Gatling technical support](https://gatlingcorp.atlassian.net/servicedesk/customer/portal/8/group/12/create/59?summary=Private+Locations&description=Contact%20email%3A%20%3Cemail%3E%0A%0AHello%2C%20we%20would%20like%20to%20enable%20the%20private%20locations%20feature%20on%20our%20organization.).
- A Gatling Enterprise control plane [token](https://docs.gatling.io/reference/install/cloud/private-locations/introduction/#token), stored in a Kubernetes Secret of type Opaque.
- A running Kubernetes cluster (v1.19 or later), or a local [Minikube](https://minikube.sigs.k8s.io/docs/start/) environment.
- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) and [Helm](https://helm.sh/docs/intro/) installed.

## Installation

1. Add the Gatling Helm Repository:
```sh
helm repo add gatling "https://helm.gatling.io"
```

2. Update local Helm repositories:
```sh
helm repo update
```

3. Search for Gatling charts: (Tip: Include the `--versions` flag to list all chart versions.)
```sh
helm search repo gatling
```

4. Review default values and create your Secret:
- Export the default chart values:
```sh
helm show values gatling/enterprise-locations-packages > values.yaml
```
- Manually create a Kubernetes Opaque Secret containing your control plane token, then reference that Secret in your `values.yaml` under `controlPlane.env[].valueFrom.secretKeyRef`.
- For guidance on creating Secrets and mounting them as environment variables, see the [Kubernetes documentation](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#define-a-container-environment-variable-with-data-from-a-single-secret).
- Tip: Use `--version <chart-version>` for a specific chart version when exporting or installing.

> [!IMPORTANT]
> For `privateLocations.job`, this chart operates at the job template spec level, not the job spec level. See this example [JSON job definition](https://docs.gatling.io/reference/install/cloud/private-locations/kubernetes/configuration/#example-json-job-definition) for more details.

> [!TIP]
> If you need to configure HTTPS communication with custom truststores/keystores, set the following environment variables accordingly:
`KUBERNETES_TRUSTSTORE_FILE`, `KUBERNETES_TRUSTSTORE_PASSPHRASE` and/or `KUBERNETES_KEYSTORE_FILE`, `KUBERNETES_KEYSTORE_PASSPHRASE`.

> [!TIP]
> Both the Control Plane and Private Locations can be configured to use a forward proxy. Uncomment `enterpriseCloud.url` in your values.yaml and ensure the proxy rewrites the Host header to `api.gatling.io`.

5. Install the Helm chart: (Tip: Include the `--version <chart-version>` flag to install a specific version.)
```sh
helm install gatling-hybrid gatling/enterprise-locations-packages --namespace gatling --values <yaml-file/url> or --set key1=val1,key2=val2
```

### Activate Private Packages:

- To enable Private Packages, set `privatePackage.enabled` to `true`. By default, storage uses the Control Plane filesystem, creating a PersistentVolumeClaim if type = `filesystem`.

## Uninstallation

1. Remove the release:
```sh
helm uninstall gatling-hybrid -n gatling
```

2. Remove the Gatling Helm repository (optional):
```sh
helm repo remove gatling
```
