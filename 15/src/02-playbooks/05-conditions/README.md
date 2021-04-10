# Running conditional tasks

Make `~/ansible` your current directory.

# Using Ansible facts

Run the `install-updates.yml` playbook. Notice the conditional tasks running on Ubuntu (`web1`, `db1`) and RHEL/CentOS (`web2`, `db2`) systems.

```
ansible-playbook install-updates.yml
```

# Using magic variables

Update the `users.yml`, `passwords.yml` and `create-users.yml` files to reflect the database-specific changes. Follow the steps described in the chapter.

Run the `create-users.yml` playbook. Notice the conditional tasks running the web servers and database servers.

```
ansible-playbook create-users.yml
```

# Using register variables

Create the `count-users.yml` playbook and run it, targeting only the `web1` host. Notice the conditional task checking the register variable and running. Change the `max_allowed` variable to `50`. Run the playbook again. Observe the task being skipped.

```
ansible-playbook count-users.yml --limit web1
```
