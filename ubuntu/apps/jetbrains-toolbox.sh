#!/bin/bash

apt-get install -y libfuse2
wget -O /tmp/jetbrains-toolbox.tar.gz "https://data.services.jetbrains.com/products/download?platform=linux&code=TBA"
mkdir -p $HOME/.local/share/JetBrains/Toolbox
tar -xzf /tmp/jetbrains-toolbox.tar.gz -C $HOME/.local/share/JetBrains/Toolbox --strip-components=1
$HOME/.local/share/JetBrains/Toolbox/bin/jetbrains-toolbox

echo '# Add JetBrains scripts to PATH' >> $HOME/.bashrc
echo 'export PATH=$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts' >> $HOME/.bashrc
echo -e "\n" >> $HOME/.bashrc

