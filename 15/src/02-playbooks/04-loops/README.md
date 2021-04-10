# Working with loops

Make `~/ansible` your current directory.

Delete the `./group_vars` folder.

Run the `create-users1.yml` playbook targeting the `web1` webserver.

```
ansible-playbook create-users1.yml --limit web1
```

Note the three tasks executed, in the output. Now, run `delete-users2.yml` to remove the users:

```
ansible-playbook delete-users2.yml --limit web1
```

Next, run the `create-users2.yml` playbook targeting only the `web1` webserver:

```
ansible-playbook create-users2.yml --limit web1
```

Note the single task run with three iterations.

Create the `users.yml`, `passwords.yml` and `create-users.yml` files as described in the chapter. Make sure the `passwords.yml` file is encrypted. Run the `create-users.yml` playbook.

```
ansible-playbook create-users.yml
```
