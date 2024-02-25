#!/bin/sh

pcid=$1
pass=$2

# Docker
sudo curl https://get.docker.com | sh
sudo usermod -aG docker $USER

# code-server
curl -fsSL https://code-server.dev/install.sh | sh
sudo systemctl enable --now code-server@$USER
# 1秒待つ
sleep 1
# .config/code-server/config.yamlをsedコマンドで編集 127.0.0.1:8080 -> 0.0.0.0:9999、password: "password" -> password: "imagepit"
sed -i -e 's/bind-addr: 127.0.0.1:8080/bind-addr: 0.0.0.0:9999/g' ~/.config/code-server/config.yaml
sed -i -e "s/password: .*/password: $pass/g" ~/.config/code-server/config.yaml
sudo systemctl restart code-server@$USER
sudo systemctl status code-server@$USER

# cloudflared tunnel
curl -s https://raw.githubusercontent.com/imagepit/curl-sh/master/setup-remote.sh | bash -s $pcid
