#! /bin/bash

# Script installs Puma server

# Create local git repository

cd ~
git clone -b monolith https://github.com/express42/reddit.git

# then install dependencies

cd reddit && bundle install


# Create systemd unit for puma

unitFile="/etc/systemd/system/puma.service"

echo "[Unit]
Description=Puma HTTP server
After=network.target

[Service]
Type=simple
WorkingDirectory=/home/appuser/reddit
ExecStart=/usr/local/bin/puma -d
Restart=always

[Install]
WantedBy=multi-user.target
" > $unitFile

# Enable puma.service

systemctl daemon-reload
systemctl enable puma.service

