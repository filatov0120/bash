#!/bin/bash
# Install docker, docker compose, mount EBS-volume.
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
#Create dir and mount EBS
sudo mkdir /data
sudo mkfs -t xfs /dev/nvme1n1
sudo mount /dev/nvme1n1 /data
#Add auto mount
ebs_uuid=$(sudo blkid -s UUID -o value /dev/nvme1n1)
echo "UUID=$ebs_uuid  /data  xfs  defaults,nofail  0  2" | sudo tee -a /etc/fstab
