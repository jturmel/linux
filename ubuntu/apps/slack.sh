#!/bin/bash

# TODO Dynamically determine the most up-to-date file to grab
#   as Slack removes old versions when they release a new one
wget -O /tmp/slack.deb "https://downloads.slack-edge.com/desktop-releases/linux/x64/4.46.99/slack-desktop-4.46.99-amd64.deb"
sudo apt install -y /tmp/slack.deb
rm /tmp/slack.deb
