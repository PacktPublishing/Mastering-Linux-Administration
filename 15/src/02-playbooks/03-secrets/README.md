# Working with secrets

Make `~/ansible` your current directory.

Create the `passwords.yml` file with the following content:

```
---
webuser: { password: changeit! }
```

Encrypt the file using Ansible Vault. Enter/create a password when prompted.

```
ansible-vault encrypt passwords.yml
```

Verify the `passwords.yml` file is encrypted:

```
cat passwords.yml
```

Start building the `create-user.yml` playbook. Add a `debug` task to make sure we can read secrets from the Vault:

```
---
- name: Create a specific user on all web servers
  hosts: webservers
  become: yes
  tasks:
    - name: Get the password for '{{ user.name }}' from the Vault
      include_vars:
        file: passwords.yml

    - name: Debug passwords
      debug:
        msg: "{{ webuser.password }}"
```

Run the playbook and notice the password being decrypted:

```
ansible-playbook create-user.yml
```

To view the content of the encrypted file, run:

```
ansible-vault view passwords.yml
```

To edit the encrypted file, type:

```
ansible-vault edit passwords.yml
```

To re-encrypt the file with a different password, run:

```
ansible-vault rekey passwords.yml
```

Add the following code to the `create-user.yml` playblook to debug the vault access:

```
---
- name: Create a specific user on all web servers
  hosts: webservers
  become: yes
  tasks:
    - name: Get the password for {{ username }} from Vault
      include_vars:
        file: passwords.yml

    - name: Debug password for {{ username }}
      debug:
        msg: "{{ vars[username]['password'] }}"
```

Save the playbook and run it with:

```
ansible-playbook --ask-vault-pass create-user.yml
```

To make your Ansible Vault password automatically available when running a playbook that requires vault access, start by creating a regular text file, preferably in your home directory, e.g., `~/vault.pass`.  Add the vault password to this file in a single line. Then you can choose either of the following options, to use the vault password file:
* Create the following environment variable:  
  `export ANSIBLE_VAULT_PASSWORD_FILE=~/vault.pass`
* Add the following line to your `ansible.cfg` file in the `[defaults]` section:  
  `vault_password_file = ~/vault.pass`

Now you can run the `create-user` playbook without the `--ask-vault-pass` option:

```
ansible-playbook create-user.yml
```
