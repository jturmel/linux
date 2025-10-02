#!/bin/bash

sudo apt-get update
sudo apt-get install jq

bash -c "$(curl -fsSL https://raw.githubusercontent.com/marverix/gah/refs/heads/master/tools/install.sh)"
