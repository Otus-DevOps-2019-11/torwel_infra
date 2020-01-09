#! /bin/bash

# Script installs Puma server

# Create local git repository

cd ~
git clone -b monolith https://github.com/express42/reddit.git

# then install dependencies

cd reddit && bundle install

# run server

puma -d

