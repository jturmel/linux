#!/usr/bin/env bash

WORK_DIR=$(dirname "$0")

# Remove unwanted packages
. $WORK_DIR/remove-alacritty.sh
. $WORK_DIR/remove-basecamp.sh
. $WORK_DIR/remove-discord.sh
. $WORK_DIR/remove-hey.sh
. $WORK_DIR/remove-omarchy-chromium.sh
. $WORK_DIR/remove-signal.sh
. $WORK_DIR/remove-spotify.sh

