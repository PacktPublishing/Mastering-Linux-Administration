# Working with AKS

Login to your Azure account.

```
az login
```

Create a resource group for the Kubernetes service.

```
az group create --name "k8s-packt" --location westus
```

Get a list of available Kubernetes versions for our location.

```
az aks get-versions --location westus -o table
```

Create a Kubernetes cluster with 2 nodes. Use `--kubernetes-version` to specify a version.

```
az aks create \
    --resource-group "k8s-packt" \
    --name "k8s-packt" \
    --generate-ssh-keys \
    --node-count 2
```

Download and install `kubectl`: https://kubernetes.io/docs/tasks/tools/#kubectl. Alternatively, you can use the Azure CLI to install `kubectl`:

```
az aks install-cli
```

Get the cluster credentials and merge the remote kubeconfig into our local environment. `kubectl` will read the local kubeconfig to connect to the remote AKS cluster using certificate-based user authentication.

```
az aks get-credentials \
    --resource-group "k8s-packt" \
    --name "k8s-packt"
```

Get the current kubeconfig contexts.

```
kubectl config get-contexts
```

Set the current context to our AKS cluster.

```
kubectl config use-context "k8s-packt"
```

Rename the current context to `k8s-packt-aks`.

```
kubectl config rename-context k8s-packt k8s-packt-eks
```

Get cluster nodes. Note the control plane node is not listed.

```
kubectl get nodes
```

Get pods. Note the control plane pods are not listed.

```
kubectl get pods --all-namespaces
```

Delete the `k8s-packt` cluster in AKS.

```
az aks delete \
    --resource-group "k8s-packt" \
    --name "k8s-packt" #--yes --no-wait
```

Rename the AKS kubeconfig context from `k8s-packt` to `k8s-packt-aks`.

```
kubectl config rename-context k8s-packt k8s-packt-aks
```

Retrieve the access credentials from the AKS cluster.

```
az aks get-credentials \
  --name k8s-packt \
  --resource-group k8s-packt
```

Check the contexts, make sure the AKS cluster is included.

```
kubectl config get-contexts
```

Rename the AKS kubeconfig context to "k8s-packt-aks"

```
kubectl config rename-context k8s-packt k8s-packt-aks
```
