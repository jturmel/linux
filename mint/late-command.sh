#!/bin/bash
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
apt-get update
apt-get install -y google-chrome-stable

# Install JetBrains Toolbox
apt-get install -y libfuse2
wget -O /tmp/jetbrains-toolbox.tar.gz "https://data.services.jetbrains.com/products/download?platform=linux&code=TBA"
mkdir -p $HOME/.local/.share/JetBrains/Toolbox
tar -xzf /tmp/jetbrains-toolbox.tar.gz -C $HOME/.local/.share/JetBrains/Toolbox --strip-components=1
$HOME/.local/.share/JetBrains/Toolbox/jetbrains-toolbox
