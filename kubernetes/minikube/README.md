## Deplying to a local Minikube cluster

Tested under Linux and macOS.


## Extra tools required

You will need to have [minikube] installed, of course.


## Bring the cluster up

The script [minikube-start](./minikube-start) creates a local Minikube
cluster with the following add-ons enabled:

* `default-storageclass`
* `ingress`
* `storage-provisioner`

It might take up to 10 minutes for the cluster to be available:

    $ ./minikube-start
    [.. Lots of output follow ...]
    🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default

The cluster should be up and running now. Try the following commands to
config its state:

    $ minikube status
    minikube
    type: Control Plane
    host: Running
    kubelet: Running
    apiserver: Running
    kubeconfig: Configured

    $ kubectl get nodes
    NAME       STATUS   ROLES           AGE     VERSION
    minikube   Ready    control-plane   6m39s   v1.30.0


## Deploy pygeoapi and the PostgreSQL instance

Create the Kubernetes namespace to host pygeoapi:

    $ kubectl create ns pygeoapi-demo
    namespace/pygeoapi-demo created

From this directory, generate and apply the Kubernetes manifests with the
following command:

    $ kustomize build . | kubectl apply -f -
    configmap/database-config-fmfm5hc2m5 created
    configmap/initdb-kcdht48dgb created
    configmap/pygeoapi-config-4gmh495k44 created
    secret/database-credentials-4ctbtbgmb5 created
    service/postgresql created
    service/pygeoapi created
    deployment.apps/pygeoapi created
    statefulset.apps/postgresql created
    ingress.networking.k8s.io/pygeoapi created

If you want to run ingress with an external IP, you'll need to run a [minikube tunnel][] in a
separate terminal:

```bash
minikube tunnel
Status:	
	machine: minikube
	pid: 115758
	route: 10.96.0.0/12 -> 192.168.49.2
	minikube: Running
	services: []
    errors: 
		minikube: no errors
		router: no errors
		loadbalancer emulator: no errors
```

In this example run, your local pygeo instance will be accessible
at `192.168.49.2`.

Enable ingress with:

```bash
minikube addons enable ingress
```

You can check that ingress is running with the following command:

    $ kubectl -n pygeoapi-demo get ingress

In case your address is **not** `192.168.49.2`, you need update the IP address inside
[./kustomization.yaml](./kustomization.yaml):

    [...]
    patches:
      - target:
          kind: Deployment
          name: pygeoapi
        patch: |
          - op: add
            path: /spec/template/spec/containers/0/env/-
            value:
              name: SAMPLE_CONFIG_PYGEOAPI_URL
              value: http://192.168.49.2

And then regenerate and reapply the Kubernetes manifests:

    $ kustomize build . | kubectl apply -f -

At this points the pygeoapi pods should not be available yet --- because
they're trying to access the lake dataset from the PostgreSQL instance,
and we haven't loaded it yet:

    $ kubectl -n pygeoapi-demo get pods
    NAME                        READY   STATUS             RESTARTS      AGE
    postgresql-0                1/1     Running            0             4m32s
    pygeoapi-7b5d79d6fb-hnbrt   0/1     CrashLoopBackOff   5 (71s ago)   4m32s
    pygeoapi-7b5d79d6fb-xgt7q   0/1     CrashLoopBackOff   5 (66s ago)   4m32s

## Load the lakes dataset

Refer to the [instructions in the parent directory](../README.md) to load
the dataset into the PostgreSQL instance. Come back here when you have
successfully loaded the data.


## Restart the pygeo pods

Now that the PostgreSQL data contains the expected tables, restart the
pygeoapi pods:

    $ kubectl -n pygeoapi-demo rollout restart deployment pygeoapi
    deployment.apps/pygeoapi restarted

After a short while they should now be up and running:

    $ kubectl -n pygeoapi-demo get pods
    NAME                     READY   STATUS    RESTARTS   AGE
    postgresql-0             1/1     Running   0          8m50s
    pygeoapi-9d996dc-bmwpw   1/1     Running   0          32s
    pygeoapi-9d996dc-t4cm6   1/1     Running   0          32s

And, most importantly, you should see the pygeoapi instance at the expected
IP address:

    $ curl http://192.168.49.2
    [ ... the JSON top-level view ...]


[minikube]: https://minikube.sigs.k8s.io/docs/
[minikube tunnel]: https://minikube.sigs.k8s.io/docs/handbook/accessing/
