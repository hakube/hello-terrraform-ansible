#!/bin/bash

echo $'# Terraform maintained user data \nPort 8822\nAllowTCPForwarding yes' >> /etc/ssh/sshd_config
sudo ufw allow ssh
systemctl restart sshd.service