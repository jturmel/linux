#!/bin/bash

cd $HOME
wget -O google-cloud-cli.tar.gz "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz"
tar -xf google-cloud-cli.tar.gz
./google-cloud-sdk/install.sh --quiet
rm -If google-cloud-cli.tar.gz

search_string="google-cloud-sdk"
file_path="$HOME/.zshrc"

if ! grep -qF "$search_string" "$file_path"; then
  echo "Installing .zshrc includes."
  echo "### google-cloud-sdk start ###" >>$HOME/.zshrc
  echo 'source $HOME/google-cloud-sdk/completion.zsh.inc' >>$HOME/.zshrc
  echo "### google-cloud-sdk end ###" >>$HOME/.zshrc
else
  echo "Skipping .zshrc includes, already installed."
fi

# Setup link in /usr/bin so that gcloud is accessible for all tools that may need to call it
sudo ln -s ~/google-cloud-sdk/bin/gcloud /usr/bin/gcloud
