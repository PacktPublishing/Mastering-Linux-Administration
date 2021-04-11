# Using kubectl

Table of contents:
* [Connecting to a Kubernetes cluster](#connecting-to-a-kubernetes-cluster)
* [Working with kubectl](#working-with-kubectl)
* [Enabling kubectl auto-completion](#enabling-kubectl-auto-completion})

## Connecting to a Kubernetes cluster

Make a backup of the current kubeconfig.

```
cp ~/.kube/config ~/.kube/config.old
```

Copy the remote kubeconfig from the control plane node.

```
scp packt@172.16.191.6:~/.kube/config /tmp/config.cp
```

Merge the two config files into a new one.

```
KUBECONFIG=~/.kube/config:/tmp/config.cp \
    kubectl config view --flatten > /tmp/config.new
```

Replace current kubeconfig with the new one.

```
mv /tmp/config.new ~/.kube/config
```

Clean-up temporary files (optional).

```
rm ~/.kube/config.old /tmp/config.cp
```

Get the current contexts.

```
kubectl config get-contexts
```

Rename the new kubeconfig context to `k8s-packt`.

```
kubectl config rename-context \
    kubernetes-admin@kubernetes \
    k8s-packt
```

Make the new kubeconfig context default.

```
kubectl config use-context k8s-packt
```

## Working with kubectl


Get cluster info.

```
kubectl cluster-info
```

Get a detailed view of cluster nodes.

```
kubectl get nodes --output=wide
```

Get pods in the default namespace.

```
kubectl get pods
```

Get all pods (from all namespaces).

```
kubectl get pods --all-namespaces
```

Get pods running in the `kube-system` namespace.

```
kubectl get pods --namespace kube-system
```

Get all resources running in the system.

```
kubectl get all --all-namespaces
```

Get all API object types.

```
kubectl api-resources
```

Provide detailed documentation about the nodes API object (resource type).

```
kubectl explain nodes
kubectl explain nodes.spec
```

Provide detailed information about nodes.

```
kubectl describe nodes
kubectl describe nodes k8s-n1
```

Get context specific help.

```
kubectl --help
kubectl config -h
kubectl get pods -h
```

## Enabling kubectl auto-completion


Install `bash-completion` if it's not installed.

```
sudo apt-get install -y bash-completion
```

Source the `kubectl` auto-completion.

```
echo "source <(kubectl completion bash)" >> ~/.bashrc
```

Source the bash profile for immediate effect.

```
source ~/.bashrc
```

`kubectl` auto-complete is now enabled via `[Tab]` `[Tab]`, e.g.

```
kubectl create [Tab] [Tab]
```
