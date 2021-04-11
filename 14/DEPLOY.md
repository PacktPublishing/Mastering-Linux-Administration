# Deploying applications with Kubernetes

Table of contents:
* [Imperative deployments](#imperative-deployments)
* [Declarative deployments](#declarative-deployments)

## Imperative deployments

Create a deployment (`packt`).

```
kubectl create deployment packt --image=nginxdemos/hello
```

Create a pod (`packt-web`).

```
kubectl run packt-web --image=nginxdemos/hello
```

Get the pods (with detailed information).

```
kubectl get pods -o wide
```

Describe pods in detail.

```
kubectl describe pod packt-5dc77bb9bf-bnzsc
kubectl describe pod packt-web
```

List the containers running on cluster node `k8s-n1` (`172.16.191.8`). First you need to SSH into the node.

```
ssh packt@172.16.191.8
sudo crictl --runtime-endpoint unix:///run/containerd/containerd.sock ps
```

Access the shell inside the `packt-web` container.

```
kubectl exec -it packt-web -- /bin/sh
```

Explore a few commands inside the container.

```
# Get running processes.
ps aux

# Get the internal IP address (should match the pod IP).
ifconfig | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}' | grep -v '127.0.0.1'

# Get the hostname (should match the pod name).
hostname

# Exit the container terminal with `Ctrl+D` or:
exit
```

Run a `test` pod containing the `curl` utility. We keep the pod _alive_ with `sleep` (10 min), otherwise the pod would keep crashing and restarting due to its `curl` entrypoint.

```
kubectl run test --image=curlimages/curl sleep 600
```

Get the internal pod IP address of `packt-web`. In our case the pod IP is `192.168.215.66`.

```
kubectl get pods packt-web -o jsonpath='{.status.podIP}{"\n"}'
```

Test with a simple curl command.

```
kubectl exec test -- curl http://192.168.215.66
```

Check out the logs for `packt-web`. We should see the trace corresponding to the `curl` command above.

```
kubectl logs packt-web
```

Verify that the Nginx logs are redirected to `stdout` and `stderr`.

```
kubectl exec packt-web -- ls -la /var/log/nginx
```

Delete the `test` pod.

```
kubectl delete pods test
```

Get the resources related to the `packt` deployment.

```
kubectl get deployments -l app=packt
kubectl get replicasets -l app=packt
kubectl get pods -l app=packt
```

Explore the `packt` resources more closely. Don't forget to use the `kubectl` auto-completion.

```
kubectl describe deployment packt | more
kubectl describe replicaset packt | more
kubectl describe pod packt-5dc77bb9bf-bnzsc | more
```

### Exposing deployments as services

Create a service for the `packt` deployment with the following flags:
* `--port=80`: expose port 80 externally
* `--target-port=80`: map to port 80 internally
* `--type=NodePort`: make the service accessible outside the cluster

> **Important note:**  
> Without the `--type=NodePort` flag, the default service type would be `ClusterIP` and the service endpoint would only be accessible within the cluster. See: https://kubernetes.io/docs/concepts/services-networking/service/

```
kubectl expose deployment packt \
    --port=80 \
    --target-port=80 \
    --type=NodePort
```

Get the `packt service.

```
kubectl get service packt
```

Get the IP address and hostname for all nodes.

```
kubectl get nodes \
    -o jsonpath='{range .items[*]}{.status.addresses[*].address}{"\n"}'
```

Point a browser to any of the cluster node IP addresses with the service port, e.g. http://172.16.191.6:32081. The web page should display the server IP and name matching the pod. Here's the `kubectl` command to retrieve the pod IP address and name.

```
kubectl get pod packt-5dc77bb9bf-bnzsc \
    -o jsonpath='{.status.podIP}{"\n"}{.metadata.name}{"\n"}'
```

### Scaling application deployments

Get the details about the `packt` deployment. Look for the current value of replicas.

```
kubectl describe deployment packt
```

Scale up the `packt` deployment to `10` replicas.

```
kubectl scale deployment packt --replicas=10
```

Get the pods of the `packt` deployment.

```
kubectl get pods -l app=packt
```

Install `Lynx` text browser for a better illustration of the load-balancing effect.

```
sudo apt-get install -y lynx
```

Use `Lynx` to access and refresh the application service endpoint. Hit `Ctrl+R` to refresh every few seconds. Observe the pod changing with each request. Hit `Q` followed by `Enter`, to exit.

```
lynx 172.16.191.6:32081
```

Scale back the `packt` deployment to `3` replicas.

```
kubectl scale deployment packt --replicas=3
```

Query the `packt` pods.

```
kubectl get pods -l app=packt
```

Clean up resources.

```
kubectl delete service packt
kubectl delete deployment packt
kubectl delete pod packt-web
```

Make sure we have a clean slate.

```
kubectl get all
```

## Declarative deployments

Capture the deployment YAML with `--dry-run`.

```
kubectl create deployment packt --image=nginxdemos/hello \
    --dry-run=client --output=yaml
```

Redirect dry-run deployment to a file (`packt.yaml`).

```
kubectl create deployment packt --image=nginxdemos/hello \
    --dry-run=client --output=yaml > packt.yaml
```

Validate the deployment manifest (`packt.yaml`).

```
kubectl apply -f packt.yaml --dry-run=client
```

Deploy the `packt.yaml` manifest.

```
kubectl apply -f packt.yaml
```

Check the deployed resources.

```
kubectl get all -l app=packt
```

Create the manifest file (`packt-svc.yaml`) for the service exposing our deployment (`packt`).

```
kubectl expose deployment packt \
    --port=80 \
    --target-port=80 \
    --type=NodePort \
    --dry-run=client --output=yaml > packt-svc.yaml
```

Validate the service deployment manifest.

```
kubectl apply -f packt-svc.yaml --dry-run=client
```

Deploy service manifest.

```
kubectl apply -f packt-svc.yaml
```

Get the status of the `packt` resources.

```
kubectl get all -l app=packt
```

Indentify the service endpoint and port, to test the application endpoint. Point your browser to the related endpoint, e.g. http://172.16.191.6:31168.

Edit the `packt.yaml` manifest, and locate the following section:

```
spec:
  replicas: 1
```

Change the number of replicas to `10` (for scale-out):

```
spec:
  replicas: 10
```

Save the file and redeploy.

```
kubectl apply -f packt.yaml
```

Query the current deployment and note the added pods.

```
kubectl get all -l app=packt
```

Scale back the current deployment to `3` pods, with on-the-fly editing.

```
kubectl edit deployment packt
```

Locate the related section and change from `10` to `3`. The change would not be reflected in the deployment manifest (`packt.yaml`), but would be persisted in the cluster (`etcd`)

```
spec:
  replicas: 3
```

Save and exit when done.

Verify the deployment.

```
kubectl get deployment packt
```

Clean up resources.

```
kubectl delete service packt
kubectl delete deployment packt
```

Make sure we have a clean slate.

```
kubectl get all
```