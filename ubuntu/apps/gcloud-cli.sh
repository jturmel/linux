#!/bin/bash
#
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz
tar -xf google-cloud-cli-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh --quiet
rm google-cloud-cli-linux-x86_64.tar.gz

echo "### google-cloud-sdk start ###" >> $HOME/.zshrc
echo 'source $HOME/google-cloud-sdk/completion.zsh.inc' >> $HOME/.zshrc
echo 'source $HOME/google-cloud-sdk/path.zsh.inc' >> $HOME/.zshrc
echo "### google-cloud-sdk end ###" >> $HOME/.zshrc

