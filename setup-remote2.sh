#!/bin/sh

value=$1

# Switch to root
# sudo su -

# Install Cloudflare CLI
sudo sh -c "cd /root && wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb"
sudo sh -c "cd /root && dpkg -i cloudflared-linux-amd64.deb"

# Download Cloudflare Settings
# cpuのarchitectureを取得
cpu_arch=$(uname -m)
# amd64の場合
if [ $cpu_arch = "x86_64" ]; then
  sudo sh -c "cd /root && curl -Lo ./vsremo https://raw.githubusercontent.com/imagepit/curl-sh/master/bin/linux_amd64 && chmod +x ./vsremo && ./vsremo set $value"
# arm64の場合
elif [ $cpu_arch = "aarch64" ]; then
  sudo sh -c "cd /root && curl -Lo ./vsremo https://raw.githubusercontent.com/imagepit/curl-sh/master/bin/linux_arm64 && chmod +x ./vsremo && ./vsremo set $value"
fi

# Run Cloudflare Tunnel
sudo cloudflared --config /root/.cloudflared/config.yml service install