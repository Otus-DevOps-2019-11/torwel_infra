#! /bin/bash

# This script add mongo repo and key: 

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xd68fa50fea312927
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

# Then installs MongoDB:

sudo apt update
sudo apt install -y mongodb-org

# Turn on autostart and run MongoDB:

sudo systemctl enable mongod
sudo systemctl start mongod
sudo systemctl status mongod

