# RudderStack Helm Chart

[RudderStack](https://rudderlabs.com) is a platform for collecting, storing and routing customer event data to dozens of tools.

## TL;DR;

```bash
$ git clone git@github.com:rudderlabs/rudderstack-helm.git
$ cd rudderstack-helm/
$ helm install my-release ./ --set rudderWorkspaceToken="<workspace token from the dashboard>"
```

## Introduction

This chart creates a Rudderstack deployment on a [Kubernetes](http://kubernetes.io) cluster
using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubectl installed and connected to your kubernetes cluster
- Helm installed
- Workspace token from the [dashboard](https://app.rudderlabs.com). Set up your account and copy your workspace token from the top of the home page.

## Installing the Chart

To install the chart with the release name `my-release`, from the root directory of this repo:

```bash
$ helm install my-release ./ --set rudderWorkspaceToken="<workspace token from the dashboard>"
```

The command deploys Rudderstack on the default Kubernetes cluster configured with `kubectl`. The [configuration](#configuration) section lists the most significant parameters that can be configured during deployment.

## Upgrading the Chart

To update configuration or version of the images used, change the configuration and run:

```bash
$ helm upgrade my-release ./ --set rudderWorkspaceToken="<workspace token from the dashboard>"
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm uninstall my-release
```

This removes all the components created by this chart.

## Open source Control Plane
- if you are using open source control plane you need to set the value controlPlaneJSON to true in [values.yaml](values.yaml). which will read config from [workspaceConfig.json](./workspaceConfig.json) file
## Configuration

The following table lists the configurable parameters of the Rudderstack chart and their default values.

| Parameter                           | Description                                                                                         | Default                  |
| ----------------------------------- | --------------------------------------------------------------------------------------------------- | ------------------------ |
| `rudderWorkspaceToken`              | Workspace token from the dashboard                                                                  | `-`                      |
| `backend.image.repository`          | Container image repository for the backend                                                          | `rudderlabs/rudder-server`     |
| `backend.image.version`                 | Container image tag for the backend. [Available versions](https://hub.docker.com/r/rudderlabs/rudder-server/tags)                                                                 | `v0.1.6`                  |
| `backend.image.pullPolicy`     | Container image pull policy for the backend image                                                   | `Always`           |
| `transformer.image.repository`      | Container image repository for the transformer                                                      | `rudderlabs/transformer` |
| `transformer.image.version`             | Container image tag for the transformer. [Available versions](https://hub.docker.com/r/rudderlabs/rudder-transformer/tags)                                                            | `v0.1.2`                  |
| `transformer.image.pullPolicy` | Container image pull policy for the transformer image                                               | `Always`           |
| `ingress.enabled`                   | If `true`, an ingress is created                                                                    | `true`                   |
| `ingress.tls`                       | A list of [ingress tls](https://kubernetes.io/docs/concepts/services-networking/ingress/#tls) items | `[]`                     |
| `backend.extraEnvVars`              | Extra environments variables to be used by the backend in the deployments                           | `Refer values.yaml file` |
|`controlPlaneJSON`                   | If `true`, backend will read config from the workspaceConfig.json file  |  `false` |

Each of these parameters can be changed in values.yaml. Or specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set backend.image.version=v0.1.6 \
  --set ingress.enabled=false \
  ./
```

**Note:** Configuration specific to
- Backend can be edited in [rudder-config.toml](https://docs.rudderlabs.com/administrators-guide/config-parameters).
- Postgres can be edited in pg_hba.conf, postgresql.conf

## Components

Installing this helm chart will deploy the following pods and containers in the configured cluster

#### POD - {Release name}-rudderstack-0 :
- rudderstack-backend
- rudderstack-telegraf-sidecar

#### POD - {Release name}-rudderstack-postgresql-0 :
- {Release name}-rudderstack-postgresql

#### POD - {Release name}-rudderstack-transformer-xxxxxxxxxx-xxxxx:
- transformer
