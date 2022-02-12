# What is RudderStack?

[RudderStack](https://rudderstack.com/) is a **customer data pipeline** tool for collecting, routing and processing data
from your websites, apps, cloud tools, and data warehouse.

More information on RudderStack can be found [here](https://github.com/rudderlabs/rudder-server).

## TL;DR;

```bash
$ git clone git@github.com:rudderlabs/rudderstack-helm.git
$ cd rudderstack-helm/charts/rudderstack
$ helm dependency build 
$ helm install my-release ./ --set rudderWorkspaceToken="<workspace token from the dashboard>"
```

## Introduction

The RudderStack Helm chart creates a Rudderstack deployment on a [Kubernetes](http://kubernetes.io) cluster using
the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubectl installed and connected to your kubernetes cluster
- Helm installed
- Workspace token from the [RudderStack dashboard](https://app.rudderstack.com). Set up your account and copy your
  workspace token from the top of the home page.

## Installing the Chart

To install the chart with the release name `my-release`, from the root directory of this repo:

```bash
$ helm install my-release ./ --set rudderWorkspaceToken="<workspace token from the dashboard>"
```

The command deploys Rudderstack on the default Kubernetes cluster configured with `kubectl`.
The [configuration](#configuration) section lists the most significant parameters that can be configured during
deployment.

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

## Developing the Chart

To run a dry-run to evaluate if the changes proposed would be applied properly we can execute:

```bash
helm template ./ | kubectl apply --dry-run=client -f -
```

## Postgres dependency

We contemplate three options on having Postgres as a dependency.

- Deploying it as a **Sidecar** in the same stateful resource
- Deploying a new Statefulset with Postgres.
- Providing an external Postgres.

### Sidecar mode

To enable the sidecar mode, specify:

```yaml
postgresql:
  mode: sidecar
  statefulset_enabled: false
```

### Stateful mode

To enable the sidecar mode, specify:

```yaml
postgresql:
  mode: statefulset
  statefulset_enabled: true
```

## HPA : Horizontal Pod Autoscaling

> Only recommended with **postgresql sidecar mode enable**.

> Currently, only supported for `backend.controlPlaneJSON:true` since the **[pre-stop hook](charts/rudderstack/pre-stop.sh)**
> reads from the local config guaranteeing that all the events reached the destination so no event is lost on
> the autoscaling down process.

Horizontal Pod Autoscaling is available in case of resource efficiency requirement.

```yaml
backend:
  terminationGracePeriodSeconds: xx
  lifecycleSleepTime: xx
  hpa:
    enabled: true
```

Also, make sure you define the `lifecycleSleepTime` & the `terminationGracePeriodSeconds` bigger
than `BatchRouter.uploadFreqInS` otherwise K8s will kill the pods before flushing the data into their destinations.

## Open-source Control Plane

If you are using open-source config-generator UI, you need to set the parameter `controlPlaneJSON` to `true` in
the `values.yaml` file. Export workspace-config from the config-generator and copy/paste the contents into
the `workspaceConfig.json` file.

```bash
$ helm install my-release ./ --set backend.controlPlaneJSON=true
 ```

## Extending the Chart

Since we are publishing the Chart under the {{ TBC by the RudderStack team }} page. It's possible to extend this Chart
by adding it as a dependency into your own Chart, so there is no need to git clone this repo for deploying RudderStack
open-source into your infrastructure.

```yaml
apiVersion: v2
name: rudderstack
description: Customer Data Pipeline tool for collecting, routing and processing data.
maintainers:
  - name: Data Platform
    email: xxxx@xxxx.com
version: 0.4.5
appVersion: 1.16.0
dependencies:
  # https://github.com/rudderlabs/rudderstack-helm
  - name: rudderstack
    version: 0.4.5
    repository: https://TBC.github.io/rudderstack-helm # To Be Confirmed by the RudderStack team
```

## GCP

If you are using Google Cloud Storage or Google BigQuery for the following cases, you have to replace the contents of
the file [rudder-google-application-credentials.json](charts/rudderstack/rudder-google-application-credentials.json)
with your service account:

- GCS as a destination
- GCS for dumping jobs
- BigQuery as a warehouse destination.

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
| `backend.extraEnvVars`              | Extra environments variables to be used by the backend in the deployments                           | `Refer values.yaml file` |
| `backend.controlPlaneJSON`                   | If `true`, backend will read config from the workspaceConfig.json file  |  `false` |

Each of these parameters can be changed in `values.yaml`. Or specify each parameter using
the `--set key=value[,key=value]` argument to `helm install`. For example:

```bash
$ helm install --name my-release \
  --set backend.image.version=v0.1.6 \
  ./
```

**Note:** Configuration specific to:

- Backend can be edited in [rudder-config.yaml](https://docs.rudderlabs.com/administrators-guide/config-parameters).
- PostgreSQL can be edited in `pg_hba.conf`, `postgresql.conf`

## Components

Installing this Helm chart will deploy the following pods and containers in the configured cluster:

#### POD - {Release name}-rudderstack-0 :

- rudderstack-backend
- rudderstack-telegraf-sidecar
- rudderstack-postgresql-sidecar

#### POD - {Release name}-rudderstack-transformer-xxxxxxxxxx-xxxxx:

- transformer

## Contact Us

For any queries related to using the RudderStack Helm Chart, feel free to start a conversation on
our [Slack](https://resources.rudderstack.com/join-rudderstack-slack) channel.
