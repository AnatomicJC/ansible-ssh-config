SSH configuration
=========

This role will configure SSH on remote server.
Have a look at these ressources:
- https://stribika.github.io/2015/01/04/secure-secure-shell.html
- https://www.guillaume-leduc.fr/securiser-secure-shell-ssh.html
- https://wiki.mozilla.org/Security/Guidelines/OpenSSH (some outdated config...)
- https://www.ssh.com/ssh/sshd_config/ (for port forwarding configuration)
- https://buzut.fr/configuration-dun-serveur-linux-ssh/ (for minimal KexAlgorithms, Ciphers, and MACs)

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

## 2FA Authentication

#### Ansible inventory setup

This role will configure SSH 2FA authentication thanks to libpam-oath.

First, set `ssh_config_totp_enabled` variable to True, and keep `ssh_config_password_authentication` to `no`.

Next, set `ssh_config_challenge_response_authentication` to `yes` and fill `ssh_config_authentication_methods` with this content:

    publickey,keyboard-interactive:pam

Then, fill `ssh_config_totp_users` with a valid user and hexkey generated with this command (**ansible-vault** is your friend to hide this sensitive data)

    head -10 /dev/urandom | sha512sum | cut -b 1-30

#### 2FA app configuration

To configure your 2FA app (Google Authenticator, FreeOTP, ...). Convert your Hex Key to base32:

    echo d5bbd79272bfca29cb99b843ff7df0 | xxd -r -p | base32 

Then generate a QRCode (replace the secret content with your generated base32):

Command line output (apt install python-qrcode):

    qr 'otpauth://totp/user@machine?secret=2W55PETSX7FCTS4ZXBB767PQ'

For PNG file output, you can use qr:

    qr 'otpauth://totp/kendo@vbox-debian?secret=P4IWWSEB5VPHZLVPMD6KU4RZ' > qrcode.png

You can also use qrencode (you can create bigger images):

    qrencode 'otpauth://totp/user@machine?secret=2W55PETSX7FCTS4ZXBB767PQ' -o qrcode.png -s15

Scan the QRCode with you 2FA App and you will be ready to go.

    ssh user@server

You will authenticate first with your SSH key, then 2FA authentication will be prompted.

#### Ressources

- https://wiki.archlinux.org/index.php/Pam_oath
- https://gist.github.com/andrewlkho/e9a8c996c4bc1df23cd2
- https://www.insecure.ws/linux/openssh_oath.html

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
