# Using roles with Ansible Galaxy

Make `~/ansible` your current directory.

## Creating roles

Add the following entry to the `~/ansible/ansible.cfg` file in the `[defaults]` section:

```
roles_path = ~/ansible
```

Initialize the `create-users` role directory:

```
ansible-galaxy init create-users 
```

Refactor the `create-users.yml`, `users.yml` and `passwords.yml` files to make them more generic.

Author the role content according to the steps described in the book:
* `defaults/main.yml` - copy/paste the variables in the `vars` section of `create-users.yml`
* `tasks/main.yml` - copy/paste the tasks from `create-users.yml` (keep the relative indentation!)
* `tests/test.yml` - create a simple playbook using the role. Copy the `users.yml`, `passwords.yml` files to the `tests` directory.
* `README.md` - explain the basic purpose and usage of the role

Test the role with the following command:

```
ansible-playbook create-users/tests/test.yml
ansible-playbook create-users/tests/test2.yml
ansible-playbook create-users/tests/test3.yml
```

Copy the `users.yml` and `passwords.yml` files in the `tests/` folder to `myusers.yml` and `mypasswords.yml` respectively:

```
cp create-users/tests/users.yml create-users/tests/myusers.yml
cp create-users/tests/passwords.yml create-users/tests/mypasswords.yml
```

Change the corresponding variables in `defaults/main.yml` to reflect the new file names:

```
users_file: myusers.yml
passwords_file: mypasswords.yml
```

Running the `test3.yml` playbook should complete successfully:

```
ansible-playbook create-users/tests/test3.yml
```

Make sure you revert the previous changes if you still plan on testing with `test.yml` and `test2.yml`. These playbooks override the role variables in the play.

## Using Ansible Galaxy

Browse the Ansible Galaxy website at: https://galaxy.ansible.com/.

## nginx

Search roles for `nginx`. Select the _Official Ansible role for NGINX_: https://galaxy.ansible.com/nginxinc/nginx. Click on the _Copy to clipboard_ button to copy the realted installation command. Copy/paste the command in the terminal and run:

```
ansible-galaxy install nginxinc.nginx -p .
```

Note the `nginxinc.nginx` folder in the local directory. Next, create the `nginx.yml` playbook and run it with:

```
ansible-playbook nginx.yml
```

## ufw

Using the terminal, search for `ufw` roles:

```
ansible-galaxy search ufw | grep 'configures ufw'
```

Select `weareinteractive.ufw`. Find out more about the role:

```
ansible-galaxy info weareinteractive.ufw
```

Look for the `download_count`:

```
ansible-galaxy info weareinteractive.ufw | grep download_count
```

Install the related `weareinteractive.ufw` role:

```
ansible-galaxy install weareinteractive.ufw
```


## firewalld

Using the Ansible Galaxy website, search for a specific `firewalld` role. Select _firewalld configuration through variables_: https://galaxy.ansible.com/FlatKey/firewalld. Install the related `firewalld` role:

```
ansible-galaxy install flatkey.firewalld
```

Note the `flatkey.firewalld` folder in the local directory.

