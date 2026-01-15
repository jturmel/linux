#!/usr/bin/env bash

sudo pacman -S flatpak --noconfirm
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.discordapp.Discord

