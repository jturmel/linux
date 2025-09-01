#!/bin/bash

# Add apt repositories
sudo add-apt-repository -y ppa:neovim-ppa/stable
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# Update list of available packages
sudo apt update

curl -L https://jturmel.github.io/linux/mint/apps/git.sh | sh /dev/stdin
curl -L https://jturmel.github.io/linux/mint/apps/chrome.sh | sh /dev/stdin
curl -L https://jturmel.github.io/linux/mint/apps/nodejs.sh | sh /dev/stdin
curl -L https://jturmel.github.io/linux/mint/apps/jetbrains-toolbox.sh | sh /dev/stdin
curl -L https://jturmel.github.io/linux/mint/apps/github.sh | sh /dev/stdin
curl -L https://jturmel.github.io/linux/mint/apps/neovim.sh | sh /dev/stdin
curl -L https://jturmel.github.io/linux/mint/apps/discord.sh | sh /dev/stdin

# Install Google Cloud CLI
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz
tar -xf google-cloud-cli-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh --quiet
rm google-cloud-cli-linux-x86_64.tar.gz

# Install Google Cloud SQL Proxy
wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O /usr/local/bin/cloud_sql_proxy
chmod +x /usr/local/bin/cloud_sql_proxy

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

# Set Cinnamon theme to Dracula
mkdir -p $HOME/.themes
wget https://github.com/dracula/gtk/archive/master.zip -O /tmp/dracula-gtk.zip
unzip -o /tmp/dracula-gtk.zip -d $HOME/.themes/
mv $HOME/.themes/gtk-master $HOME/.themes/Dracula
gsettings set org.cinnamon.desktop.interface gtk-theme "Dracula"
gsettings set org.cinnamon.desktop.wm.preferences theme "Dracula"
rm /tmp/dracula-gtk.zip


# Install Slack
wget -O /tmp/slack.deb "https://downloads.slack-edge.com/linux_releases/slack-desktop-4.36.137-amd64.deb"
apt install -y /tmp/slack.deb
rm /tmp/slack.deb

# Install LazyVim
echo "Installing LazyVim..."
# Remove existing Neovim config if it exists
rm -rf $HOME/.config/nvim
# Clone LazyVim starter template
git clone https://github.com/LazyVim/starter $HOME/.config/nvim
# Remove the .git directory from the cloned LazyVim config
rm -rf $HOME/.config/nvim/.git
echo "LazyVim installation complete. Launch nvim to finalize setup."

# Install Gemini CLI
npm install -g @google/gemini-cli

# Cleanup
curl -L https://jturmel.github.io/linux/mint/cleanup.sh | sh /dev/stdin

