#!/bin/bash

# Add apt repositories
sudo add-apt-repository -y ppa:neovim-ppa/stable
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# Update list of available packages
sudo apt update

# tools
curl -L https://jturmel.github.io/linux/mint/apps/git.sh | sh /dev/stdin
curl -L https://jturmel.github.io/linux/mint/apps/nodejs.sh | sh /dev/stdin
curl -L https://jturmel.github.io/linux/mint/apps/gcloud-cli.sh | sh /dev/stdin
curl -L https://jturmel.github.io/linux/mint/apps/google-cloud-sql-proxy.sh | sh /dev/stdin
curl -L https://jturmel.github.io/linux/mint/apps/gemini-cli.sh | sh /dev/stdin

# apps
curl -L https://jturmel.github.io/linux/mint/apps/chrome.sh | sh /dev/stdin
curl -L https://jturmel.github.io/linux/mint/apps/jetbrains-toolbox.sh | sh /dev/stdin
curl -L https://jturmel.github.io/linux/mint/apps/github.sh | sh /dev/stdin
curl -L https://jturmel.github.io/linux/mint/apps/neovim.sh | sh /dev/stdin
curl -L https://jturmel.github.io/linux/mint/apps/discord.sh | sh /dev/stdin
curl -L https://jturmel.github.io/linux/mint/apps/slack.sh | sh /dev/stdin

# config
curl -L https://jturmel.github.io/linux/mint/config/oh-my-zsh.sh | sh /dev/stdin
curl -L https://jturmel.github.io/linux/mint/config/theme.sh | sh /dev/stdin
curl -L https://jturmel.github.io/linux/mint/config/lazyvim.sh | sh /dev/stdin

# Cleanup
curl -L https://jturmel.github.io/linux/mint/cleanup.sh | sh /dev/stdin

