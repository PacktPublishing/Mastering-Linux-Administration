# Using variables in playbooks

Make `~/ansible` your current directory.

Edit the `create-user.yml` file previously created and adjust it as follows:

```
---
- name: Create a specific user on all web servers
  hosts: webservers
  become: yes
  tasks:
    - name: Create the '{{ username }}' account
      user:
        name: "{{ username }}"
        state: present
```

Keep iterating with the `create-user.yml` and `delete-user.yml` files, according to the content in the chapter. See the related iterations in the `01`, `02`, ... directories. Here are the relevant commands:

```
ansible-playbook create-user.yml
ansible-playbook delete-user.yml
```

To create a different user (`webadmin`) with a different password (`changeme!`), run the following command:

```
ansible-playbook -e '{"username": "webadmin", "password": "changeme!"}' create-user.yml
```

Remove the `webuser` and `webadmin` accounts, before proceeding with the next steps:

```
ansible-playbook delete-user.yml
ansible-playbook -e '{"username": "webadmin"}' delete-user.yml
```
