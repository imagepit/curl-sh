#!/bin/sh

# Switch to root
sudo su -

# Install Cloudflare CLI
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb

# Download Cloudflare Settings
sh -c "docker run --rm -v .:/root imagepit/vsremo vsremo set $1"

# Run Cloudflare Tunnel
sudo cloudflared --config ~/.cloudflared/config.yml service install