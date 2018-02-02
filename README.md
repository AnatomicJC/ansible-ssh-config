SSH configuration
=========

This role will configure SSH on remote server.
Have a look at these ressources:
- https://stribika.github.io/2015/01/04/secure-secure-shell.html
- https://www.guillaume-leduc.fr/securiser-secure-shell-ssh.html
- https://wiki.mozilla.org/Security/Guidelines/OpenSSH

Role Variables
--------------

- `ssh_config_*_pubkeys`: SSH public keys who will be pushed. Have a look at default/main.yml for an example
  - You will have to define "base" public keys on your inventory/group_vars/all file. These "base" public keys will be added on all servers. You can add to these "base" public keys "group" and "host" public keys who will be merged in a ssh_config_pubkeys variable.
  - Take care to don't define same users in differents base, group or host
context !!
- `ssh_config_authorized_keys_file`: define AuthorizedKeysFile
- `ssh_config_match_config`: block text who contains Match User/Group configuration, used for sftp access
- `ssh_config_permit_root_login`: Default without-password, you should not modify this value
- `ssh_config_password_authentication`: Default no, you should not modify this value
- `ssh_config_generate_user_ssh_key`: Default no, create user ssh key while create user
- `ssh_config_authorized_keys_command`: Default False, set True will enable the SSH AuthorizedKeysCommand  feature
- `ssh_config_sshauth_login`: htaccess login of sshauth service
- `ssh_config_sshauth_passwd`: htaccess passwd of sshauth service
- `ssh_config_sshauth_fqdn`: sshauth service FQDN
- `ssh_config_more_security`: Default True, Enable Ciphers, Macs and KexAlgorithms restrictions

Example Playbook
----------------

    - hosts: servers
      roles:
         - { role: AnatomicJC.ssh-config }

Related projects
----------------

There is a `sshauth` service for SSH `AuthorizedKeysCommand` feature: https://github.com/AnatomicJC/sshauth

License
-------

WTFPL

Author Information
------------------

Look commits for Author Information
