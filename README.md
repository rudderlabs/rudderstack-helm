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
 - Workspace token from the [dashboard](app.rudderlabs.com). Set up your account and copy your workspace token from top of the home page.

## Installing the Chart

To install the chart with the release name `my-release`, from the root directory of this repo:

```bash
$ helm install --name my-release ./
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