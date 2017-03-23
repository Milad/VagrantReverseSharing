#!/usr/bin/env bash

# Variables and Settings
export SMB_USER="ubuntu"
export SMB_PASS="123456"

read -d '' SMB_CNFG <<"EOF"
[global]
    workgroup = WORKGROUP
    security = user
[share]
    comment = Ubuntu File Server Share
    path = /var/www
    browsable = yes
    guest ok = yes
    read only = no
    # create mask = 0755
EOF

# Install Samba

sudo apt-get update
sudo apt-get install samba -y -q

# Create directory for sharing
sudo mkdir -p /var/www
sudo chown $SMB_USER:root /var/www

# Configure
sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.bak
echo "$SMB_CNFG" | sudo tee /etc/samba/smb.conf

(echo "$SMB_USER"; echo "$SMB_USER") | sudo smbpasswd -sa -U $SMB_USER

# Restart
sudo service smbd restart
sudo service nmbd restart
