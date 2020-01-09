#!/bin/bash

# Ruby and bundler check installation

ruby_installed=0
ruby_installed=$(dpkg -s ruby-full | grep -c Status)

echo
echo "Ruby installation status: $ruby_installed"

if [ 0 -eq $ruby_installed ]
then
	echo "Installing ruby and bundler:"
	sudo apt update
	sudo apt install -y ruby-full ruby-bundler build-essential
else
	echo "Ruby is installed."
fi


# MangoDB check installation

mongo_installed=0
mongo_installed=$(dpkg -s mongodb-org | grep -c Status)

echo
echo "Mongo installation status: $mongo_installed"

if [ 0 -eq $mongo_installed ]
then
	echo "Adding MongoDB repository and its key"
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xd68fa50fea312927
	sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
	echo "Installing MongoDB:"
	sudo apt update
	sudo apt install -y mongodb-org

	echo "Turn on autostart and run MongoDB:"
	sudo systemctl enable mongod
	sudo systemctl start mongod
else
	echo "MongoDB is installed."
fi



# Puma server check installation

puma_installed=0
puma_installed=$(puma -V | grep 'puma version' -c)
echo
echo "Puma installation status: $puma_installed"

if [ 0 -eq $puma_installed ]
then
	echo "Creating local Puma  git repository:"
	cd ~
	git clone -b monolith https://github.com/express42/reddit.git
	
	echo "Installing Puma dependencies:"
	cd reddit && bundle install
	
#	run server
	puma -d
else
	echo "Puma is installed."
fi
