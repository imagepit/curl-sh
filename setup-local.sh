#!/bin/sh

# /etc/sudoersにパスワードなしでsudoできるように設定
sudo sed -i -e "s/ALL$/NOPASSWD: ALL/g" /etc/sudoers

# Install Docker
sudo curl https://get.docker.com | sh
sudo usermod -aG docker ubuntu
