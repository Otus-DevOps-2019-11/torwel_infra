#! /bin/bash

# This script installs Ruby and Bundle

set -e

apt update
apt install -y ruby-full ruby-bundler build-essential

