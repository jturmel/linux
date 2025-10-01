#!/bin/bash

sudo update-alternatives --install /usr/bin/editor editor $(which nvim) -1000
sudo update-alternatives --config editor
