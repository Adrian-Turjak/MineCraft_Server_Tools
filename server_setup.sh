#!/bin/bash

# first lets ensure java is at the latest version
echo "setting up java"
sudo sudo apt-get --assume-yes purge openjdk-\*
sudo add-apt-repository --assume-yes ppa:webupd8team/java
sudo apt-get --assume-yes update
sudo apt-get install --assume-yes oracle-java8-installer
echo "java setup completed"


# SET THESE VARIABLES FIRST!
server_url="http://ftb.cursecdn.com/FTB2/modpacks/FTBInfinity/2_4_2/FTBInfinityServer.zip"
zip_file="FTBInfinityServer.zip"

echo "getting server files"
wget $server_url
sudo apt-get install --assume-yes unzip
unzip $zip_file -d mc_server

echo "Running FTBInstall"
cd mc_server
. ./FTBInstall.sh
cd ..
echo "FTBInstall completed"

echo "Updating ServerStart.sh script"
# Update this line to the amount of RAM you want the server to use.
find mc_server/ServerStart.sh -type f -exec sed -i 's/-Xms512M -Xmx2048M/-Xms1000M -Xmx3500M/g' {} \;
echo "ServerStart.sh script updated"

echo "Setting EULA to true"
find mc_server/eula.txt -type f -exec sed -i 's/eula=false/eula=true/g' {} \;
echo "EULA updated"

echo "setting up server as service"
server_path=$(readlink -f mc_server/ServerStart.sh)
sudo cp scripts/minecraft-server.conf /etc/init/
sudo find /etc/init/minecraft-server.conf -type f -exec sudo sed -i "s@<server_path>@$server_path@" {} \;
sudo initctl reload-configuration
echo "server setup as service"

echo "Starting minecraft server"
sudo start minecraft-server
echo "Minecraft server started"

# now setup the cronjob for monitoring.
# TODO: CRONJOB AND MONITORING STUFF GOES HERE:
