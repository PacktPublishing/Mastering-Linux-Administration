# Working with EKS

Download and install `eksctl`.

```
curl --silent --location \
    "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | \
    tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin/
```

Download and install `kubectl`.

```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

Create a Kubernetes cluster on EKS.

```
eksctl create cluster \
    --name k8s-packt \
    --nodes 2 \
    --node-volume-size 20 \
    --region us-west-2 \
    --managed
```

Get the current kubeconfig contexts.

```
kubectl config get-contexts
```

Set the current context to our EKS cluster.

```
kubectl config use-context \
    iam-root-account@k8s-packt.us-west-2.eksctl.io
```

Rename the current context to `k8s-packt-eks`.

```
kubectl config rename-context \
    iam-root-account@k8s-packt.us-west-2.eksctl.io \
    k8s-packt-eks
```

Get cluster nodes. Note the control plane node is not listed.

```
kubectl get nodes
```

Get pods. Note the control plane pods are not listed.

```
kubectl get pods --all-namespaces
```

Delete the `k8s-packt` cluster on EKS.

```
eksctl delete cluster --name k8s-packt
```

Update local kubeconfig to include the EKS cluster.

```
aws eks update-kubeconfig \
    --name k8s-packt \
    --region us-west-2
```

Check the contexts, make sure the EKS cluster is included.

```
kubectl config get-contexts
```

Rename the EKS kubeconfig context to `k8s-packt-eks`.

```
kubectl config rename-context \
    arn:aws:eks:us-west-2:106842557074:cluster/k8s-packt \
    k8s-packt-eks
```