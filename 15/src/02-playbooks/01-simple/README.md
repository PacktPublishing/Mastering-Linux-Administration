# Working with Ansible playbooks

This document provides a few examples using Ansible playbooks.

Make `~/ansible` your current directory.

## Creating a simple playbook

Build your first Ansible playbook (`create-user.yml`) for creating a user (`webuser`). Copy/paste the following into a `create-user.yml` file:

```
---
- name: Create a specific user on all web servers
  hosts: webservers
  become: yes
  tasks:
    - name: Create the 'webuser' account
      user:
        name: webuser
        state: present
```

Run the `create-user.yml` playbook with:

```
ansible-playbook create-user.yml
```

Using the `delete-user.yml` playbook, run it selectively to only target the `ubuntu` host group:

```
ansible-playbook delete-user.yml --limit ubuntu
```

Let's re-run the `delete-user.yml` playbook, this time without a limited scope:

```
ansible-playbook delete-user.yml
```
