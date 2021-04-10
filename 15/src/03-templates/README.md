# Using templates with Jinja2

Make `~/ansible` your current directory.

Create the `./templates` folder in your current project directory:

```
mkdir -p ~/ansible/templates
```

## Creating a message-of-the-day template

Create the `motd.j2` Jinja2 template file in `~/ansible/templates` and the `update-motd.yml` playbook in your current project directory. Run the `update-motd.yml` playbook:

```
ansible-playbook update-motd.yml
```

Verify the `/etc/motd` file on any of the remote hosts (e.g., `web1`) and make sure it contains the expected message.

```
ansible web1 -a "cat /etc/motd"
```

SSH into any of the remote hosts (e.g., `web1`) and notice the motd message in the terminal.

## Creating a hosts file template

Create the `hosts.j2` Jinja2 template file in `~/ansible/templates` and the `update-hosts.yml` playbook in your current project directory. Run the `update-hosts.yml` playbook:

```
ansible-playbook update-hosts.yml
```

Verify the `/etc/hosts` file on any of the remote hosts (e.g., `web1`) and make sure it contains the expected message.

```
ansible web1 -a "cat /etc/hosts"
```

SSH into one of the remote hosts (e.g., `web1`) and ping any of the other remote hosts by name.

```
ssh packt@web1
ping db2
```