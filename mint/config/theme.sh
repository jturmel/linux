#!/bin/bash

mkdir -p $HOME/.themes
wget https://github.com/dracula/gtk/archive/master.zip -O /tmp/dracula-gtk.zip
unzip -o /tmp/dracula-gtk.zip -d $HOME/.themes/
mv $HOME/.themes/gtk-master $HOME/.themes/Dracula
gsettings set org.cinnamon.desktop.interface gtk-theme "Dracula"
gsettings set org.cinnamon.desktop.wm.preferences theme "Dracula"
rm /tmp/dracula-gtk.zip

