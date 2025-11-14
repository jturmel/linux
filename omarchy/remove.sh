#!/bin/sh

WORK_DIR=$(dirname "$0")

# Remove unwanted packages
. $WORK_DIR/remove-omarchy-chromium.sh
. $WORK_DIR/remove-alacritty.sh

