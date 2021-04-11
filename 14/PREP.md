# Preparing the environment

Installing Kubernetes on virtual machines. Run these steps on each VM.

Disable swap immediately.

```
sudo swapoff -a
```

Persist disabled swap with system reboots.

```
sudo sed -i '/\s*swap\s*/s/^\(.*\)$/# \1/g' /etc/fstab
```

Enable the kernel modules required by `containerd`.

```
sudo modprobe br_netfilter
sudo modprobe overlay
```

Persist the loading of kernel modules with system reboots.

```
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
br_netfilter
overlay
EOF
```

Set the CRI required `sysctl` params, to persist across system reboots.

```
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
```

Apply `sysctl` params immediately, without reboot.

```
sudo sysctl --system
```

Install `containerd`.

```
sudo apt-get update
sudo apt-get install -y containerd
```

Create a default `containerd` configuration.

```
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
```

Use the `systemd` `cgroup` driver with the `containerd` runtime. Open `/etc/containerd/config.toml` for editing (`sudo nano ...`). Locate the related section and add the additional lines, adjusting the appropriate indentation (very important!).

```
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  ...
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true
```

Save the `/etc/containerd/config.toml` file and restart `containerd`.

```
sudo systemctl restart containerd
```

Install packages needed to use the Kubernetes `apt` repository.

```
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl
```

Download the Google GPG key.

```
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg \
    https://packages.cloud.google.com/apt/doc/apt-key.gpg
```

Add the Kubernetes `apt` repository.

```
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] \
    https://apt.kubernetes.io/ kubernetes-xenial main" | \
    sudo tee /etc/apt/sources.list.d/kubernetes.list
```

Install the Kubernetes packages.

```
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
```

Pin the versions of Kubernetes packages.

```
sudo apt-mark hold containerd kubelet kubeadm kubectl
```

Ensure `containerd` and `kubelet` services are enabled upon reboot.

```
sudo systemctl enable containerd
sudo systemctl enable kubelet
```

Check the status of Kubernetes services.

```
sudo systemctl status containerd
sudo systemctl status kubelet
```
