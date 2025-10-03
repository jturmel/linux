#!/bin/bash

if [ -e "$HOME/.gitignore" ]; then
  rm "$HOME/.gitignore"
fi

touch "$HOME"/.gitignore
curl -fsSL https://jturmel.github.io/dotfiles/.gitignore -o "$HOME/.gitignore"

git config --global core.excludesFile "$HOME/.gitignore"
