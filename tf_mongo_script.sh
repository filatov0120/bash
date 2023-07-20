#!/bin/bash
#Create dir and mount EBS
sudo mkdir /data
sudo mkfs -t xfs /dev/nvme1n1
sudo mount /dev/nvme1n1 /data
#Add auto mount
ebs_uuid=$(sudo blkid -s UUID -o value /dev/nvme1n1)
echo "UUID=$ebs_uuid  /data  xfs  defaults,nofail  0  2" | sudo tee -a /etc/fstab

#Install MongoDB
sudo apt-get install -y gnupg curl
curl -fsSL https://pgp.mongodb.com/server-6.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg \
   --dearmor
echo \
   "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] \
   https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse"| \
   sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

sudo apt-get update
sudo apt-get install -y mongodb-org
sudo usermod -aG mongodb ubuntu
sudo chown mongodb:mongodb /data
#Reboot instance
sudo shutdown -r now
