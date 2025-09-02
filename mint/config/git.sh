#!/bin/bash

if [ -e "$HOME/.gitignore" ]; then
  return 0
else
  touch "$HOME"/.gitignore
  curl -fsSL https://jturmel.github.io/dotfiles/.gitignore -o "$HOME/.gitignore"
fi

git config --global core.excludesFile "$HOME/.gitignore"
