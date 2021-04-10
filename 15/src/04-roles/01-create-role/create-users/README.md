Create users
============

Creates users.

Requirements
------------

### Users file

The users file (e.g. `users.yml`) requires the following format (example):

```
list:
  - username: testuser
    comment: Test user

  - username: testadmin
    comment: Test admin

  - username: testdev
    comment: Test dev
```

### Passwords file

The passwords file (e.g. `passwords.yml`) requires the following format (example):

```
testuser:
  password: bb37e5d1

testadmin:
  password: 7705b8a4

testdev:
  password: 8365b176
```

The username entries in the passwords file should match the corresponding items in the users file.
The passwords file should be encrypted.

Role Variables
--------------

`users_file`: the name of the users file

`passwords_file`: the name of the passwords file

Example Playbook
----------------

`test.yml`:

```
---
- hosts: all
  become: yes
  roles:
  - role: create-users
    vars:
      users_file: users.yml
      passwords_file: passwords.yml
```

`test2.yml`:

```
---
- hosts: all
  become: yes
  tasks:
  - name: Create users
    include_role:
      name: create-users
    vars:
      users_file: users.yml
      passwords_file: passwords.yml
```

License
-------

BSD

Author Information
------------------

Packt: Mastering Linux Administration
