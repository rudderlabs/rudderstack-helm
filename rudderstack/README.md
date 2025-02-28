# What is RudderStack?

[RudderStack](https://rudderstack.com/) is a **customer data pipeline** tool for collecting, routing and processing data from your websites, apps, cloud tools, and data warehouse.

More information on RudderStack can be found [here](https://github.com/rudderlabs/rudder-server).

## TL;DR;

```bash
$ git clone git@github.com:rudderlabs/rudderstack-helm.git
$ cd rudderstack-helm/
$ helm install my-release ./ --set rudderWorkspaceToken="<workspace token from the dashboard>"
```

## Introduction

The RudderStack Helm chart creates a Rudderstack deployment on a [Kubernetes](http://kubernetes.io) cluster
using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubectl installed and connected to your kubernetes cluster
- Helm installed
- Workspace token from the [RudderStack dashboard](https://app.rudderstack.com). Set up your account and copy your workspace token from the top of the home page.

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

## Open-source Control Plane

If you are using open-source config-generator UI, you need to set the parameter `controlPlaneJSON` to `true` in the `values.yaml` file. Export workspace-config from the config-generator and copy/paste the contents into the `workspaceConfig.json` file.

```bash
$ helm install my-release ./ --set backend.controlPlaneJSON=true
 ```

## GCP

If you are using Google Cloud Storage or Google BigQuery for the following cases, you have to replace the contents of the file [rudder-google-application-credentials.json](rudder-google-application-credentials.json) with your service account:

 - GCS as a destination
 - GCS for dumping jobs
 - BigQuery as a warehouse destination.

## Configuration

The following table lists the configurable parameters of the Rudderstack chart and their default values.

| Parameter                           | Description                                                                                         | Default                  |
| ----------------------------------- | --------------------------------------------------------------------------------------------------- | ------------------------ |
| `commonLabels` | Labels to apply to all resources | `{}` |
| `rudderWorkspaceToken`              | Workspace token from the dashboard                                                                  | `-`                      |
| `rudderWorkspaceTokenExistingSecret`    | Secret with workspace token (overrides `rudderWorkspaceToken`)                                                                 | `-`                      |
| `backend.image.repository`          | Container image repository for the backend                                                          | `rudderlabs/rudder-server`     |
| `backend.image.version`                 | Container image tag for the backend. [Available versions](https://hub.docker.com/r/rudderlabs/rudder-server/tags)                                                                 | `v0.1.6`                  |
| `backend.image.pullPolicy`     | Container image pull policy for the backend image                                                   | `Always`           |
| `backend.ingress.annotations` | Annotations to be added to backend ingress | `{}` |
| `backend.ingress.labels` | Labels to be added to backend ingress | `{}` |
| `backend.service.annotations` | Annotations to be added to backend service | `{"service.beta.kubernetes.io/aws-load-balancer-backend-protocol":"http"}` |
| `backend.service.labels` | Labels to be added to backend service | `{}` |
| `backend.podLabels` | Labels to add to the backend pod container metadata | `{}` |
| `backend.podAnnotations` | Annotations to be added to backend pods | `{}` |
| `backend.labels` | Labels to be added to the controller StatefulSet and other resources that do not have option to specify labels | `{}` |
| `backend.config.overrides` | object | `{}` | rudder-server config overrides See [config parameters](https://docs.rudderlabs.com/administrators-guide/config-parameters) for more details |
| `transformer.image.repository`      | Container image repository for the transformer                                                      | `rudderstack/transformer` |
| `transformer.image.version`             | Container image tag for the transformer. [Available versions](https://hub.docker.com/r/rudderstack/rudder-transformer/tags)                                                            | `latest`                  |
| `transformer.image.pullPolicy` | Container image pull policy for the transformer image                                               | `Always`           |
| `backend.extraEnvVars`              | Extra environments variables to be used by the backend in the deployments                           | `Refer values.yaml file` |
| `backend.controlPlaneJSON`                   | If `true`, backend will read config from the workspaceConfig.json file  |  `false` |
| `serviceAccount.create` | Enable service account creation. | `true` |
| `serviceAccount.annotations` | Annotations to be added to the service account. | `{}` |
| `serviceAccount.name` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. | `""` |
| `transformer.commonLabels` | Labels to apply to all transformer resources | `{}` |

Each of these parameters can be changed in `values.yaml`. Or specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```bash
$ helm install --name my-release \
  --set backend.image.version=v0.1.6 \
  ./
```

**Note:** Configuration specific to:

- Backend can be edited in [rudder-config.yaml](https://github.com/rudderlabs/rudderstack-helm/blob/master/rudder-config.yaml). or in values.yaml under `backend.config.overrides`.
- PostgreSQL can be edited in `pg_hba.conf`, `postgresql.conf`

## Components

Installing this Helm chart will deploy the following pods and containers in the configured cluster:

#### POD - {Release name}-rudderstack-0 :
- rudderstack-backend
- rudderstack-telegraf-sidecar

#### POD - {Release name}-rudderstack-postgresql-0 :
- {Release name}-rudderstack-postgresql

#### POD - {Release name}-rudderstack-transformer-xxxxxxxxxx-xxxxx:
- transformer

## Contact Us

For any queries related to using the RudderStack Helm Chart, feel free to start a conversation on our [Slack](https://resources.rudderstack.com/join-rudderstack-slack) channel.
