# Configuring the Control Plane node

This document describes the step for configuring the Kubernetes control plane (CP) node.

Download the `Calico` pod networking manifest. Modify the `CALICO_IPV4POOL_CIDR` subnet if needed.

```
curl https://docs.projectcalico.org/manifests/calico.yaml -O
```

Create a cluster configuration file (`k8s-config.yaml`). Disregard the warning about missing `Docker` runtime.

```
kubeadm config print init-defaults | tee k8s-config.yaml
```

Make the following changes in the config file. See the corresponding commands further down:
* `localAPIEndpoint.advertiseAddress`: should point to the CP node's IP address
* `nodeRegistration.criSocket`: point from `docker` to `containerd`
* Set the `cgroup driver` for the `kubelet` to `systemd`, since it's not set in this file yet. The default is `cgroupfs`.
* `kubernetesVersion` should match the Kubernetes version we installed (check with `kubectl` version)

Change `localAPIEndpoint.advertiseAddress` to the CP node's IP address. Replace with your VM's IP address.

```
sed -i 's/  advertiseAddress: 1.2.3.4/  advertiseAddress: 172.16.191.6/' k8s-config.yaml
```

Point the CRI Socket to `containerd`.

```
sed -i 's/  criSocket: \/var\/run\/dockershim.sock/  criSocket: \/run\/containerd\/containerd.sock/' k8s-config.yaml
```

Change the Kubernetes version to match the current `kubadm` version.

```
sed -i 's/kubernetesVersion: v1.20.0/kubernetesVersion: v1.20.4/' k8s-config.yaml
```

Set the `kubelet`'s `cgroupDriver` to `systemd`, matching `containerd`'s `cgroup` driver.

```
cat <<EOF | cat >> k8s-config.yaml
---
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
cgroupDriver: systemd
EOF
```

Bootstrap the Kubernetes cluster. Failing to specify the `--cri-socket` option parameter results in the following error:

> ```
> error execution phase preflight: docker is required for container runtime: exec: "docker": > executable file not found in $PATH
> ```

```
sudo kubeadm init \
    --config=k8s-config.yaml \
    --cri-socket /run/containerd/containerd.sock
```

Enable the current user for cluster administration.

```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Create the `Calico` overlay network for pods.

```
kubectl apply -f calico.yaml
```

List all pods.

```
kubectl get pods --all-namespaces
```

List the current nodes.

```
kubectl get nodes
```