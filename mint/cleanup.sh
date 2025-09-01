#!/bin/bash

sudo apt purge -y firefox
sudo apt purge -y thunderbird

rm -r $HOME/.mozilla
rm -r $HOME/.cache/mozilla

sudo apt autoremove --purge

