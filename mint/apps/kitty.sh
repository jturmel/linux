#!/bin/bash

curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# Place the kitty.desktop file somewhere it can be found by the OS
cp $HOME/.local/kitty.app/share/applications/kitty.desktop $HOME/.local/share/applications/
# If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
cp $HOME/.local/kitty.app/share/applications/kitty-open.desktop $HOME/.local/share/applications/
# Update the paths to the kitty and its icon in the kitty desktop file(s)
sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" $HOME/.local/share/applications/kitty*.desktop
# Make xdg-terminal-exec (and hence desktop environments that support it use kitty)
echo 'kitty.desktop' > $HOME/.config/xdg-terminals.list
update-desktop-database $HOME/.local/share/applications

sudo ln -sf $HOME/.local/kitty.app/bin/kitty $HOME/.local/kitty.app/bin/kitten /usr/bin/
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/kitty 50

# Setup Dracula
mkdir -p $HOME/.config/kitty
wget -O $HOME/.config/kitty/dracula.conf https://raw.githubusercontent.com/dracula/kitty/master/dracula.conf
echo "include ./dracula.conf" >> $HOME/.config/kitty/kitty.conf

