# Configuring a worker node

This document describes the steps required to join a worker node to a Kubernetes cluster.

Retrieve the `kubeadm join` command provided at the end of the bootstrap process, in the output of the `kubeadm init` command. It should look similar to:

>```
> kubeadm join 172.16.191.6:6443 \
>  --token abcdef.0123456789abcdef \
>  --discovery-token-ca-cert-hash sha256:bf5d3a2b9526e98f7403ec4a07cf052b961b3201913c040cd4e6e28f8818d8c2
>```

If you forgot to copy the command, you can retrieve the related information with the following commands, at the control plane node's terminal (on `k8s-cp1`). Switch to the control plane node's terminal (`k8s-cp1`),

Get the current bootstrap tokens.

```
kubeadm token list
```

If your token expired or simply to create a new one.

```
kubeadm token create
```

Get the discovery token CA cert hash.

```
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | \
    openssl rsa -pubin -outform der 2>/dev/null | \
    openssl dgst -sha256 -hex | sed 's/^.* //'
```

If you choose to generate a new token, you may use the following streamlined command to print out the full `kubeadm join` command with the required parameters:

```
kubeadm token create --print-join-command
```

Switch to the node's terminal (`k8s-n1`). Join the node to the with the following command:

```
sudo kubeadm join 172.16.191.6:6443 \
    --token abcdef.0123456789abcdef \
    --discovery-token-ca-cert-hash sha256:bf5d3a2b9526e98f7403ec4a07cf052b961b3201913c040cd4e6e28f8818d8c2
```
