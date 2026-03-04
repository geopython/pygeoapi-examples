# pygeoapi Helm Chart

This Helm chart deploys a **pygeoapi** instance, a server that publishes geospatial data using the OGC API - Features Standard from the Open Geospatial Consortium (OGC). This chart is designed to be flexible and easy to configure, allowing you to customize the deployment to fit your needs. 🚀

## Why Helm?

Helm is a package manage for kubernetes: it helps you manage Kubernetes applications. Helm Charts help you define, install, and upgrade even the most complex Kubernetes application.

## Requirements

To install this chart locally, you'll need a Kubernetes cluster running on your machine, such as:
- [kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
- [minikube](https://minikube.sigs.k8s.io/docs/start/)
- [CRC/OpenShift Local](https://developers.redhat.com/products/openshift-local/overview)
- [Docker Desktop](https://docs.docker.com/desktop/) with Kubernetes enabled.

And a cluster client: [kubectl](https://kubernetes.io/pt-br/docs/tasks/tools/) ([oc](https://docs.okd.io/4.18/cli_reference/openshift_cli/getting-started-cli.html) for openshift local)

And [Helm](https://helm.sh/), of course... Get install how-to here: https://helm.sh/docs/intro/install/


## Local Installation

Once your local cluster is up and running, you can install the chart directly from your local file system.

First, navigate to the chart's directory:

```bash
cd path/to/your/pygeoapi-helm-chart
```

### Default deploy install
Next, use the `helm install` command, specifying the release name and the local chart path (`.`) :

```bash
helm install [YOUR_RELEASE_NAME] .
```

### Install with custom values.yaml
To customize the installation, you can create a custom `values.yaml` file and pass it during installation:

```yaml
# custom values.yaml example
ingress:
  enabled: true
  hosts:
    - host: "ogcapi-pygeoapi.minikube.local" 
      paths:
        - path: /
          pathType: ImplementationSpecific

service:
  type: NodePort  # minikube single node

settings:
  config:
    enabled: true
    name: pygeoapi-custom-config
    isEncrypted: true # false -> configMap, true -> secret
  serverAdmin: false
  hotReload: True
  wsgi:
    workers: 5
    workerTimeout: 6000
    workerClass: gevent
```
To modify pygeoapi's behavior, check the "pygeoapi settings"session below.

Now, to deploy pygeoapi with custom values.yaml, just run the lines below

```bash
# first create a configmap with pygeoapi config file
# if config.enabled=true and config.isEncrypted=false
kubectl create configmap pygeoapi-custom-config --from-file=local.config.yml=path/to/custom/pygeoapi-config.yml

# ... or create a secret, if you have sensitive information
# (config.enabled=true and config.isEncrypted=true)
kubectl create secret generic pygeoapi-custom-config --from-file=local.config.yml=path/to/custom/pygeoapi-config.yml

# then install
helm install [YOUR_RELEASE_NAME] . -f my-custom-values.yaml
```

### Openshift-specific settings

In OpenShift some additional config needs to be set, because pygeoapi still has issues running as non-root user. Three additional steps needs to be set before helm install

1. Add serviceAccount
```yaml
# custom values.yaml example
# We have to define a ServiceAccount for deployment
...
serviceAccount:
  create: true 
  name: pygeoapi
...
```

2. Create a RoleBinding allowing the service account (-z parameter) to run pods as AnyUID, on pygeoapi's project (-n parameter). See below

```bash
# run as kubeadmin or any user capable
oc adm policy add-scc-to-user anyuid -z pygeoapi -n teste
```

3. Create configmap or secret, if necessary, like kubectl but changing it to oc.

```bash
# first create a configmap with pygeoapi config file
# if config.enabled=true and config.isEncrypted=false
oc create configmap pygeoapi-custom-config --from-file=local.config.yml=path/to/custom/pygeoapi-config.yml

# ... or create a secret, if you have sensitive information
# (config.enabled=true and config.isEncrypted=true)
oc create secret generic pygeoapi-custom-config --from-file=local.config.yml=path/to/custom/pygeoapi-config.yml

# then install
helm install [YOUR_RELEASE_NAME] . -f my-custom-values.yaml
```

* In *deploys* directory, **there's an example of a customized values for minikube and CRC/OpenShift Local**. 

This will deploy the pygeoapi application to your local cluster, allowing you to test configurations and verify functionality before pushing it to a production environment.


## Configuration Parameters

This chart is configured via the `values.yaml` file. Below is a detailed description of each available parameter.

### Application Image

| Parameter | Description | Default Value |
| :--- | :--- | :--- |
| `replicaCount` | The number of pygeoapi replicas. Increase for higher availability and processing capacity. | `1` |
| `image.repository` | The Docker image repository for pygeoapi to be used. | `docker.io/ndscprm/pygeoapi` |
| `image.pullPolicy` | The image pull policy. `IfNotPresent` prevents downloading if the image already exists locally. | `IfNotPresent` |
| `image.tag` | The specific Docker image tag for the pygeoapi version. | `"0.21.0-rootless"` |
| `imagePullSecrets` | A list of authentication secrets for pulling images from private repositories. | `[]` |
| `nameOverride` | Overrides the chart name when creating Kubernetes resources. | `""` |
| `fullnameOverride` | Overrides the full chart name when creating Kubernetes resources. | `""` |

* This helm chart uses a modified pygeoapi image, because of OpenShift's security requirements. To use official pygeoapi image (v0.21.0), it's required to run the container as root.

### Service Account

| Parameter | Description | Default Value |
| :--- | :--- | :--- |
| `serviceAccount.create` | If `true`, a Service Account is created for the application. | `true` |
| `serviceAccount.automount` | If `true`, automatically mounts the Service Account's credentials. | `true` |
| `serviceAccount.annotations` | Annotations to be added to the Service Account. | `{}` |
| `serviceAccount.name` | The name of the Service Account to use. If empty, a name is generated. | `""` |

### Pod Security and Context

| Parameter | Description | Default Value |
| :--- | :--- | :--- |
| `podAnnotations` | Annotations to be added to the Pod. | `{}` |
| `podLabels` | Labels to be added to the Pod. | `{}` |
| `podSecurityContext` | The security context for the Pod. For example, `fsGroup` to define the filesystem group ID. | `{}` |
| `securityContext` | The security context for the container. For example, `runAsNonRoot` to ensure the process does not run as root. | `{}` |

### Service and Exposure

| Parameter | Description | Default Value |
| :--- | :--- | :--- |
| `service.type` | The Kubernetes service type to expose pygeoapi. | `ClusterIP` |
| `service.port` | The service port where pygeoapi will be exposed. | `8080` |

### Ingress

| Parameter | Description | Default Value |
| :--- | :--- | :--- |
| `ingress.enabled` | If `true`, an Ingress is created to expose pygeoapi externally. | `false` |
| `ingress.className` | The name of the Ingress class to be used. | `""` |
| `ingress.annotations` | Additional annotations for the Ingress. Useful for integrations like `cert-manager`. | `{}` |
| `ingress.hosts` | A list of hosts and paths to route traffic to pygeoapi. | `[]` |
| `ingress.tls` | A list of TLS secrets and associated hosts to encrypt traffic. | `[]` |

### pygeoapi Settings

| Parameter | Description | Default Value |
| :--- | :--- | :--- |
| `settings.config.enabled` | If `true`, mounts the pygeoapi configuration file (`local.config.yml`). | `true` |
| `settings.config.name` | The name of the ConfigMap or Secret containing the configuration. | `pygeoapi-config` |
| `settings.config.isEncrypted` | If `true`, reads the configuration from a Secret; otherwise, from a ConfigMap. | `false` |
| `settings.config.mountPath` | The full path where the configuration file will be mounted inside the container. | `/pygeoapi/local.config.yml` |
| `settings.config.readOnly` | If `true`, mounts the file as read-only. | `true` |
| `settings.openapi` | The path to the pygeoapi OpenAPI file. | `/tmp/pygeoapi-openapi.yml` |
| `settings.serverAdmin` | Enables or disables the server's administration interface. | `false` |
| `settings.hotReload` | Enables hot-reloading of the server. | `false` |
| `settings.wsgi.workers` | The number of workers for the WSGI server (Gunicorn). | `3` |
| `settings.wsgi.workerTimeout` | The worker timeout (in milliseconds). | `6000` |
| `settings.wsgi.workerClass` | The worker class to be used by the WSGI server. | `gevent` |

### Resources and Scaling

| Parameter | Description | Default Value |
| :--- | :--- | :--- |
| `resources` | Definition of resource limits and requests (CPU and memory) for the container. | `{}` |
| `autoscaling.enabled` | If `true`, enables the Horizontal Pod Autoscaler (HPA) to manage the number of replicas. | `false` |
| `autoscaling.minReplicas` | The minimum number of replicas when autoscaling is enabled. | `1` |
| `autoscaling.maxReplicas` | The maximum number of replicas when autoscaling is enabled. | `5` |
| `autoscaling.targetCPUUtilizationPercentage` | The CPU utilization percentage the HPA will try to maintain. | `80` |
| `autoscaling.targetMemoryUtilizationPercentage` | The memory utilization percentage the HPA will try to maintain. | `80` |

### Additional Volumes

| Parameter | Description | Default Value |
| :--- | :--- | :--- |
| `volumes` | A list of additional volumes to be added to the Deployment definition. | `[]` |
| `volumeMounts` | A list of additional volume mounts for the containers. | `[]` |

### Scheduling Configurations

| Parameter | Description | Default Value |
| :--- | :--- | :--- |
| `nodeSelector` | Node labels for selecting which nodes the Pod will be scheduled on. | `{}` |
| `tolerations` | Tolerations to schedule the Pod on nodes with taints. | `[]` |
| `affinity` | Affinity and anti-affinity rules to control Pod scheduling. | `{}` |

For a complete list of all parameters and their default values, please refer to the `values.yaml` file in the chart repository.

