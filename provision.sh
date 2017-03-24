#!/usr/bin/env bash

# Variables and Settings
export SMB_USER="ubuntu"
export SMB_PASS="123456"

# Install Samba
echo "Installing Samba"
sudo apt-get update > /dev/null
sudo apt-get install samba -y -q > /dev/null

# Create directory for sharing
sudo mkdir -p /var/www
sudo chown $SMB_USER:root /var/www

# Configure
echo "Configuring Samba"
sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.bak

read -d '' SMB_CNFG <<"EOF"
[global]
    workgroup = WORKGROUP
    security = user
[www]
    comment = Ubuntu File Server Share
    path = /var/www
    browsable = yes
    guest ok = no
    read only = no

    create mask = 644
    force create mode = 644
    security mask = 644
    force security mode = 644

    directory mask = 2775
    force directory mode = 2775
    directory security mask = 2775
    force directory security mode = 2775
EOF

echo "$SMB_CNFG" | sudo tee /etc/samba/smb.conf > /dev/null
(echo "$SMB_PASS"; echo "$SMB_PASS") | sudo smbpasswd -sa -U $SMB_USER > /dev/null

# Restart
echo "Restarting Samba"
sudo service smbd restart
# sudo service nmbd restart
