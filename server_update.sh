#!/bin/bash

# SET THESE VARIABLES FIRST!
server_url="http://ftb.cursecdn.com/FTB2/modpacks/FTBInfinity/2_4_2/FTBInfinityServer.zip"
zip_file="FTBInfinityServer.zip"

echo "getting new server files"
rm $zip_file
wget $server_url
unzip $zip_file -d mc_server_new

echo "Running FTBInstall"
cd mc_server_new
. ./FTBInstall.sh
cd ..
echo "FTBInstall completed"

echo "Stopping minecraft server"
sudo stop minecraft-server
echo "Minecraft server stopped"

echo "Updating ServerStart.sh script"
# Update this line to the amount of RAM you want the server to use.
find mc_server_new/ServerStart.sh -type f -exec sed -i 's/-Xms512M -Xmx2048M/-Xms1000M -Xmx3600M -Dfml.queryResult=confirm/g' {} \;
echo "ServerStart.sh script updated"

echo "Copying world data over"
cp -r mc_server/world mc_server_new
echo "World data copied"

echo "Copying backups over"
cp -r mc_server/backups mc_server_new
echo "Backups copied"

echo "Copying server properties"
cp mc_server/server.properties mc_server_new
echo "Server properties copied"

echo "Copying ops users"
cp mc_server/ops.json mc_server_new
echo "Ops users copied"

echo "Copying whitelist"
cp  mc_server/whitelist.json mc_server_new
echo "Whitelist copied"

echo "Copying banned player"
cp  mc_server/banned-players.json mc_server_new
echo "Banned players copied"

echo "Copying banned ips"
cp mc_server/banned-ips.json mc_server_new
echo "Banned ips copied"

echo "Setting EULA to true"
find mc_server_new/eula.txt -type f -exec sed -i 's/eula=false/eula=true/g' {} \;
echo "EULA updated"

echo "swapping folders"
mv mc_server mc_server_old
mv mc_server_new mc_server
echo "folders swapped"

echo "Starting minecraft server"
sudo start minecraft-server
echo "Minecraft server started"