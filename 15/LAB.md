# Ansible VM Environment

This document describes the Ansible lab environment using virtual machines.

## Table of contents

* [Overview](#overview)
* [Environment](#environment)
    * [neptune](#neptune)
    * [web1](#web1)
    * [web2](#web2)
    * [db1](#db1)
    * [db2](#db2)
* [Configuring the managed hosts](#configuring-the-managed-hosts)
    * [Disable sudo login password](#disable-sudo-login-password)
    * [Setting the hostname](#setting-the-hostname)
    * [Installing Python](#installing-python)
* [Configuring the Ansible control node](#configuring-the-ansible-control-node)

## Overview

Ansible control node:
* `neptune` 

Web servers:
* `web1`
* `web2`

Database servers:
* `db1`
* `db2`

## Environment

Here are the installation details for each of these platforms:

### neptune

`neptune` is the Ansible control node.

Specs:
* VM: Ubuntu Desktop 20.04.1 LTS, 2 vCPU, 2 GB RAM, 30 GB HDD
* Platform: Ubuntu 20.04.1 LTS
* Default user: `packt`, SSH enabled
* Hostname: `neptune`
* IP: `172.16.191.11`

### web1

Specs:
* VM: 2 vCPU, 2 GB RAM, 20 GB HDD
* Platform: Ubuntu Server 20.04.2 LTS
* Default user: `packt`, SSH enabled
* Hostname: `web1`
* IP: `172.16.191.12`

### web2

Specs:
* VM: 2 vCPU, 2 GB RAM, 20 GB HDD
* Platform: RHEL/CentOS 8. Installation source: http://mirror.centos.org/centos/8.3.2011/BaseOS/x86_64/os/
* Default user: `packt`, SSH enabled
* Hostname: `web2`
* IP: `172.16.191.14`

### db1

Specs:
* VM: Ubuntu Server 20.04.2 LTS, 2 vCPU, 2 GB RAM, 20 GB HDD
* Platform: Ubuntu Server 20.04.2 LTS
* Default user: `packt`, SSH enabled
* Hostname: `db1`
* IP: `172.16.191.13`

### db2

* VM: 2 vCPU, 2 GB RAM, 20 GB HDD
* Platform: RHEL/CentOS 8. Installation source: http://mirror.centos.org/centos/8.3.2011/BaseOS/x86_64/os/
* Default user: `packt`, SSH enabled
* Hostname: `web2`
* IP: `172.16.191.15`

## Configuring the managed hosts

Follow these configuration step on each managed host.

### Disable sudo login password

Each host should have a user `packt`, preferrably with the same password across all hosts.

To disable the sudo login password, edit the sudo configuration:

```
sudo visudo
```

Add the following line and save the file. Replace `packt` with your username if it's different.

```
packt ALL=(ALL) NOPASSWD:ALL
```

### Setting the hostname

Set the hostname with the following command. Replace `HOSTNAME` with `web1`, `web2`, `db1`, `db2`, on each managed host.

```
sudo hostnamectl set-hostname HOSTNAME
```

### Installing Python

Install Python. The Ubuntu 20.04 servers already have Python installed by default. Otherwise you may install it with:

```
sudo apt-get install -y python3
```

On CentOS 8 platforms, install Python 3 with the following command:

```
sudo yum install -y python38
```

## Configuring the Ansible control node

Install Ansible according to your platform. See: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html.

We use `pip` (as the recommended way of installing Ansible):

```
curl -s https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --user
rm get-pip.py
python3 -m pip install --user ansible
```

Check Ansible version:

```
ansible version
```

Prepare the SSH passwordless access to the managed hosts. Run the following commands on the Ansible control node (`neptune`).

Edit the `/etc/hosts` file and add the following records for the managed hosts:

```
172.16.191.12 web1
172.16.191.14 web2
172.16.191.13 db1
172.16.191.15 db2
```

Generate an RSA key pair (choose defaults):

```
ssh-keygen
```

Copy the public key to all managed hosts:

```
ssh-copy-id -i ~/.ssh/id_rsa.pub packt@web1
ssh-copy-id -i ~/.ssh/id_rsa.pub packt@web2
ssh-copy-id -i ~/.ssh/id_rsa.pub packt@db1
ssh-copy-id -i ~/.ssh/id_rsa.pub packt@db2
```

Create a working directory for our Ansible demos (`~/ansible`):

```
mkdir -p ~/ansible
```

Create the following Ansible inventory file in `~/ansible/hosts`:

```
[webservers]
web1
web2

[databases]
db1
db2

[ubuntu]
web1
db1

[centos]
web2
db2
```

Create the following Ansible configuration file in `~/ansible/ansible.cfg`:

```
[defaults]
inventory = ~/ansible/hosts
```

Test Ansible connectivity with all managed hosts:

```
ansible -m ping all
```
