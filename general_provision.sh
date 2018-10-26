#!/bin/bash

username = "aarba"
ssh_pub_key = "public key"

yum install -y vim python git gcc wget curl
useradd $username
mkdir /home/$username/.ssh
chmod 700 /home/$username/.ssh
echo "$ssh_pub_key" > /home/$username/.ssh/authorized_keys
chmod 600 /home/$username/.ssh/authorized_keys
chown -R $username.$username /home/$username
echo "$username ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Populate /etc/hosts

echo "192.168.56.7    kubernetes-worker-1
192.168.56.8    kubernetes-worker-2
192.168.56.9    kubernetes-controller-1
192.168.56.10    kubernetes-controller-2
192.168.56.11    kubernetes-api" >> /etc/hosts