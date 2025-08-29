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

# Install GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null
apt-get update
apt-get install -y gh

# Install Kitty terminal and Dracula theme
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
ln -sf $HOME/.local/kitty.app/bin/kitty $HOME/.local/bin/
# Desktop integration
cp $HOME/.local/kitty.app/share/applications/kitty.desktop $HOME/.local/share/applications/
sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|" $HOME/.local/share/applications/kitty.desktop
update-desktop-database $HOME/.local/share/applications

mkdir -p $HOME/.config/kitty
wget -O $HOME/.config/kitty/dracula.conf https://raw.githubusercontent.com/dracula/kitty/master/dracula.conf
echo "include ./dracula.conf" >> $HOME/.config/kitty/kitty.conf

# Install Neovim
wget -O $HOME/.local/bin/nvim https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x $HOME/.local/bin/nvim

# Setup LazyVim
rm -rf $HOME/.config/nvim
ln -sfn $(pwd)/nvim $HOME/.config/nvim
