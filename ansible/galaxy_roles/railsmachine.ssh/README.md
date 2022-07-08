Role Name
=========

`railsmachine.ssh` ensures `sshd` is installed and configures it for extra security.  Most sshd settings can be configured via Ansible; see available settings in `templates/sshd_config.j2`.  Provides optional configurations for SSH keys and SFTP-only access.

Requirements
------------

--

Role Variables
--------------

## sshd configuration

    ssh__port: 8822
    #ssh__listen_address: ''
    ssh__protocol: 2
    ssh__use_privilege_separation: 'yes'
    ssh__key_regeneration_interval: 3600
    ssh__server_key_bits: 1024
    ssh__syslog_facility: 'AUTH'
    ssh__log_level: 'INFO'
    ssh__login_grace_time: 30
    ssh__permit_root_login: 'no'
    ssh__strict_modes: 'yes'
    ssh__password_authentication: 'yes'
    ssh__x11_forwarding: 'yes'
    ssh__x11_display_offsets: 10
    ssh__print_motd: 'no'
    ssh__print_last_log: 'yes'
    ssh__tcp_keep_alive: 'yes'
    ssh__max_startups: '2:50:5'
    ssh__use_banner: false
    ssh__use_pam: 'yes'
    #ssh__allow_users: []
    #ssh__allow_groups: []
    ssh__extra_options: ''
    #ssh__client_alive:
    #  interval:
    #  count_max:

## Authorized keys

To install authorized keys, set the `ssh__authorized_keys` variable to a list of users.  For example:

    ssh__authorized_keys:
      - user: user1
        key: THE_KEY
        state: present
      - user: user2
        key: ANOTHER_KEY
        state: present
      - user: defunct_user
        key: THEIR_KEY
        state: absent

Deleting a key from the list won't remove the key; you must change its `state` to `absent`.

## SFTP-only

OpenSSH support chrooting users natively.  You can create users who will be chrooted and only allowed to use SFTP (no console access).

To enable SFTP-only access, set the `ssh__sftponly` variable:

    ssh__sftponly:
    #  chroot_directory:
      users:
        - username: sftponly
          password: $6$QSZmKWwJtt/$bJFUG363iTu8UrD5pHolb68jhcnIsF8mRJaH7fhK7Urkn57WgWPWCoaxTX5cMKJ0VtHOYEP73seWoSRwWv0Ef/
          groups: []
          directory: '/upload'

`chroot_directory` defaults to the user's home directory, but can be changed if you want to chroot to some other directory on login.

The `password` variable contains a crypted password.  You can use the `mkpasswd` utility, which comes with the `whois` package on Ubuntu, to find the crypted value of a given password.  The example password above is the crypted value of "sooper_sekrit", generated with `mkpasswd --method=sha-512`.

If `password` is not defined, Ansible will generate a random password for the user.  You can enable access for such a user by configuring authorized keys.

`groups` is a list of additional groups, besides the default `sftponly` group, to which the user should belong.

`directory` is the subdirectory inside the user's home folder, if any, that the user should be able to write to.

## Packer-skip

If this role is run in packer, SFTP-only access is default disabled, and build is the only machine able to connect to it.  When you need to add customer keys or enable SFTP-only access, rerun the role on the machine with the customer's custom ansible.

Dependencies
------------

--

Example Playbook
----------------

    - hosts: servers
      roles:
         - { role: railsmachine.ssh, ssh__sftponly: { users: [username: thisuserhasnopassword, groups: ['rails'] ] } }

License
-------

GPLv3

Author Information
------------------

Rails Machine.
