#!/bin/sh

value1=$1
value2=$2

# Slackに通知を送信
slack_webhook_url="https://hooks.slack.com/services/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"
slack_message="セットアップが完了しました。\nvalue1: $value1\nvalue2: $value2"
curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$slack_message\"}" $slack_webhook_url

# Install Docker
sudo curl https://get.docker.com | sh
sudo usermod -aG docker ubuntu

# Install code-server
curl -fsSL https://code-server.dev/install.sh | sh
sudo systemctl enable --now code-server@ubuntu
# ちょっと待つ
sleep 5
# $HOME.config/code-server/config.yamlのパスワード部分とbind-addrを「bind-addr: 0.0.0.0:9999」にsedで書き換え
sudo sed -i -e "s/password: .*/password: $value2/g" /home/ubuntu/.config/code-server/config.yaml
sudo sed -i -e "s/bind-addr: .*/bind-addr: 0.0.0.0:9999/g" /home/ubuntu/.config/code-server/config.yaml
sudo systemctl restart code-server@ubuntu

# Install Cloudflare CLI
sudo sh -c "cd /root && wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb"
sudo sh -c "cd /root && dpkg -i cloudflared-linux-amd64.deb"

# Download Cloudflare Settings
# cpuのarchitectureを取得
cpu_arch=$(uname -m)
# amd64の場合
if [ $cpu_arch = "x86_64" ]; then
  sudo sh -c "cd /root && curl -Lo ./vsremo https://raw.githubusercontent.com/imagepit/curl-sh/master/bin/linux_amd64 && chmod +x ./vsremo && ./vsremo set $value1"
# arm64の場合
elif [ $cpu_arch = "aarch64" ]; then
  sudo sh -c "cd /root && curl -Lo ./vsremo https://raw.githubusercontent.com/imagepit/curl-sh/master/bin/linux_arm64 && chmod +x ./vsremo && ./vsremo set $value1"
fi

# Run Cloudflare Tunnel
sudo cloudflared --config /root/.cloudflared/config.yml service install

