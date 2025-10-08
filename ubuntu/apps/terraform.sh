#!/bin/bash

sudo apt-get update
sudo apt-get install -y software-properties-common

if [ ! -f /usr/share/keyrings/hashicorp-archive-keyring.gpg ]; then
  echo "Installing Hashicorp keyring"
  wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(. /etc/os-release && echo "$UBUNTU_CODENAME") main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
else
  echo "Hashicorp keyring already installed"
fi

sudo apt update
sudo apt-get install terraform

terraform --version
