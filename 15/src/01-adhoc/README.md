# Working with Ansible ad-hoc commands

This document provides a few examples using Ansible ad-hoc commands.

Test the Ansible connectivity with all managed hosts:

```
ansible -m ping all
```

Verify the `packt` user is correctly configured on all hosts:

```
ansible -m user -a "name=packt state=present" all
```

We can be even more specific, and validate the user and group IDs.

```
ansible -m user -a "name=packt state=present uid=1000 group=1000" all
```

Target only a subset of the inventory:

```
ansible -m ping web1
ansible -m ping web*
ansible -m ping webservers
```

To reduce the noise of deprecated modules, add the following line to `~/ansible/ansible.cfg` file:

```
deprecation_warnings = False
```

List all Ansible modules:

```
ansible-doc --list
```

Display detailed information about a specific module (e.g., `user`):

```
ansible-doc user
```

Let's create a new user (`webuser`) on all web servers:

```
ansible -m user -a "name=webuser state=present" webservers
```

To create or update a user password, we need a password hashing library. Ansible would only accept hashed passwords. Install `passlib` on the Ansible control node.

```
pip install passlib
```

Update the password for `webuser` on all hosts within the `webservers` group:

```
ansible -m user \
    -e "passwd=changeit!" \
    -a "name=webuser \
        update_password=always \
        password={{ passwd | password_hash('sha512') }}" \
    webservers
```

Delete the `webuser` account on all hosts within the `webservers` group:

```
ansible -m user -a "name=webuser state=absent remove=yes force=yes" webservers
```

Install `nginx` on all hosts within the `webservers` group:

```
ansible -m package -a "name=nginx state=present" webservers
```

Install `mysql-server` on all hosts within the `databases` group:

```
ansible -m package -a "name=mysql-server state=present" databases
```

To delete a package, you'll use `state=absent` in the module arguments.

Install the latest updates on Ubuntu systems (ths hosts in the `ubuntu` group):

```
ansible -m apt -a "upgrade=dist update_cache=yes" ubuntu
```

Install the latest updates on RHEL/CentOS systems (the hosts in the `centos` group):

```
ansible -m yum -a "name=* state=latest update_cache=yes" centos
```

Restart the `nginx` service on all hosts in the `webservers` group:

```
ansible -m service -a "name=nginx state=restarted" webservers
```

Restart the `mysql` service on all hosts in the `databases` group, except the ones that are members of the `centos` group:

```
ansible -m service -a "name=mysql state=restarted" 'databases:!centos'
```

Restart the `mysqld` service on all hosts in the `databases` group, except the ones that are members of the `ubuntu` group:

```
ansible -m service -a "name=mysqld state=restarted" 'databases:!ubuntu'
```

Reboot all hosts in the `webservers` group:

```
ansible -m reboot -a "reboot_timeout=3600" webservers
```