#!/bin/bash

# lazyvim
echo "Installing LazyVim..."

if [ -e "$HOME./config/nvim/lazyvim.json" ]; then
  echo "LazyVim already setup, skipping.
  return 0
fi

if [ -e "$HOME/.config/nvim" ]; then
  mv $HOME/.config/nvim{,.bak}
fi

if [ -e "$HOME/.local/share/nvim" ]; then
  mv $HOME/.local/share/nvim{,.bak}
fi

if [ -e "$HOME/.local/state/nvim" ]; then
  mv $HOME/.local/state/nvim{,.bak}
fi

if [ -e "$HOME/.cache/nvim" ]; then
  mv $HOME/.cache/nvim{,.bak}
fi

# Remove existing Neovim config if it exists
rm -rf $HOME/.config/nvim
git clone https://github.com/LazyVim/starter $HOME/.config/nvim
rm -rf $HOME/.config/nvim/.git

echo "LazyVim installation complete. Launch nvim to finalize setup."
# end lazyvim
