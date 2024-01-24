#!/bin/bash

set -x
exec > >(tee -a /var/log/startup_script.log)
exec 2>&1

echo "Startup script started successfully" >> /var/log/startup_script.log

SCRIPT_USER=sudarshan97_kudli
SCRIPT_HOME=/home/$SCRIPT_USER

APP_DIR=$SCRIPT_HOME/music-stream-analytics
GITHUB_USERNAME=dev-kudli
GITHUB_URL=https://github.com/dev-kudli/music-stream-analytics.git

# Update the package list and upgrade the system
echo "Running update and upgrade..."
sudo apt-get update
sudo apt-get upgrade

# Install docker
echo "Installing Docker..."
sudo apt-get -y install docker.io

# Wait for the user to be created
while ! id -u $SCRIPT_USER >/dev/null 2>&1; do
  sleep 3
done

# Add user to group
echo "Docker without sudo setup..."
sudo groupadd docker
sudo gpasswd -a $SCRIPT_USER docker
sudo service docker restart

# Get repository contents
cd $SCRIPT_HOME
git clone $GITHUB_URL

# Docker dompose setup
echo "Installing docker-compose..."
cd $SCRIPT_HOME
mkdir -p bin
cd bin
pwd
wget https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-linux-x86_64 -O docker-compose
sudo chmod +x docker-compose

# Add path to bashrc
echo "Setup .bashrc..."
echo '' >> $SCRIPT_HOME/.bashrc
echo 'export PATH=${HOME}/bin:${PATH}' >> $SCRIPT_HOME/.bashrc
eval "$(cat $HOME/.bashrc | tail -n +10)" # A hack because source .bashrc doesn't work inside the script
sudo chmod +x docker-compose

# Test installation
echo "docker-compose version..."
docker-compose --version

echo "Startup script completed successfully" >> /var/log/startup_script.log