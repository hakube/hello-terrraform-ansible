Role Name
=========

`railsmachine.nodejs`: installs NodeJS.

Requirements
------------

--

Role Variables
--------------

     nodejs__version: '6.x'

Can also be '8.x' or'7.x'.  Version defaults to 6.x, which is NodeJS's latest LTS version.

Version could technically be any value such that `deb https://deb.nodesource.com/node_{{ nodejs__version }} {{ ansible_distribution_release }} main` is a valid repository, but this role requires version 6.x, 7.x, 8.x, 10.x, 12.x or 14.x

Dependencies
------------

--

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: app_servers
      roles:
         - { role: railsmachine.nodejs, nodejs__version: '7.x' }

License
-------

GPLv3

Author Information
------------------

Rails Machine.
