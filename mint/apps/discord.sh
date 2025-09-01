#!/bin/bash

wget -O /tmp/discord.deb "https://discord.com/api/download?platform=linux&format=deb"
sudo apt install -y /tmp/discord.deb
rm /tmp/discord.deb

