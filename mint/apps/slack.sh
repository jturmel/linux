#!/bin/bash
#
wget -O /tmp/slack.deb "https://downloads.slack-edge.com/linux_releases/slack-desktop-4.36.137-amd64.deb"
sudo apt install -y /tmp/slack.deb
rm /tmp/slack.deb

