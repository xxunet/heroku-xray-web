#!/bin/sh

mkdir -p /tmp/app

# Install XRay
wget -qO /tmp/app/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
unzip -q /tmp/app/xray.zip -d /tmp/app
install -m 755 /tmp/app/xray /usr/local/bin/xray
install -d /usr/local/etc/xray

# Install Web
mkdir -p /usr/share/caddy
echo -e "User-agent: *\nDisallow: /" >/usr/share/caddy/robots.txt
wget -qO /tmp/app/web.zip $WebPage
unzip -qo /tmp/app/web.zip -d /usr/share/caddy

# Remove Temp Directory
rm -rf /tmp/app

# Configs
mkdir -p /etc/caddy
wget -qO- $CaddyConfig | sed -e "1c :$PORT" >/etc/caddy/Caddyfile
wget -qO- $XRayConfig | sed -e "s/\$UUID/$UUID/g" >/usr/local/etc/xray/config.json

# Start
/usr/local/bin/xray -config /usr/local/etc/xray/config.json & 
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile