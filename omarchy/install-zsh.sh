#!/usr/bin/env bash

yay -S --noconfirm --needed zsh zsh-completions

chsh -s $(which zsh)

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

