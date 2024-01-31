#!/bin/sh

value=$1

# Switch to root
sudo su -

# Install Cloudflare CLI
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb

# Download Cloudflare Settings
sudo sh -c "cd /root && docker run --rm -v .:/root imagepit/vsremo vsremo set $value"

# Run Cloudflare Tunnel
sudo cloudflared --config /root/.cloudflared/config.yml service install