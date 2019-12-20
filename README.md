# RudderStack Helm Chart

[RudderStack](https://rudderlabs.com) is a platform for collecting, storing and routing customer event data to dozens of tools.

## TL;DR;

```bash
$ git clone git@github.com:rudderlabs/rudderstack-helm.git
$ cd rudderstack-helm/
$ helm install production ./
```

## Introduction

This chart creates a Rudderstack deployment on a [Kubernetes](http://kubernetes.io) cluster
using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kuberentes installed and connected a cluster
- Helm installed
- Workspace token from the [dashboard](https://app.rudderlabs.com). Set up your account and copy your workspace token from top of the home page.

## Installing the Chart

To install the chart with the release name `my-release`, from the root directory of this repo:

```bash
$ helm install --name my-release ./ --set rudderWorkspaceToken="<workspace token from the dashboard>"
```

The command deploys Rudderstack on the default kubernetes cluster configured with `kubectl`. The [confiuration](#configuration) section lists the most significant parameters that can be configured during deployment.

## Upgrading the Chart

To update configuration or version of the images used, change the configuration and run:

```bash
$ helm upgrade my-release ./
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm uninstall my-release
```

This removes all the components created by this chart.

## Configuration

The following table lists the configurable parameters of the Rudderstack chart and their default values.

| Parameter                           | Description                                                                                         | Default                  |
| ----------------------------------- | --------------------------------------------------------------------------------------------------- | ------------------------ |
| `rudderWorkspaceToken`              | Workspace token from the dashboard                                                                  | `-`                      |
| `backend.image.repository`          | Container image repository for the backend                                                          | `rudderlabs/backend`     |
| `backend.image.tag`                 | Container image tag for the backend                                                                 | `0.1.1`                  |
| `backend.image.imagePullPolicy`     | Container image pull policy for the backend image                                                   | `IfNotPresent`           |
| `transformer.image.repository`      | Container image repository for the transformer                                                      | `rudderlabs/transformer` |
| `transformer.image.tag`             | Container image tag for the transformer                                                             | `0.1.1`                  |
| `transformer.image.imagePullPolicy` | Container image pull policy for the transformer image                                               | `IfNotPresent`           |
| `ingress.enabled`                   | If `true`, an ingress is created                                                                    | `true`                   |
| `ingress.hosts`                     | A list of ingress hosts                                                                             | `[]`                     |
| `ingress.tls`                       | A list of [ingress tls](https://kubernetes.io/docs/concepts/services-networking/ingress/#tls) items | `[]`                     |
| `backend.extraEnvVars`              | Extra environments variables to be used by the backend in the deployments                           | `[]`                     |

Each of these parameters can be changed in values.yaml. Or specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set backend.image.tag=0.1.4 \
  --set ingress.enabled=false \
  ./
```

**Note:** Configuration specific to

- backend can be edited in [rudder-config.toml](https://docs.rudderlabs.com/administrators-guide/config-parameters).
- statsd client can be edited in statsd-config.js. Statsd server related info is **required** to collect stats.
- Configuration specific to postgres can be edited in pg_hba.conf, postgresql.conf

## Components

Installing this helm chart will deploy the following pods and containers in the configured cluster

#### POD1:

- Backend
- Postgres
- Statsd server

#### POD2:

- Transformer
