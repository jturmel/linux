#!/bin/sh

WORK_DIR=$(dirname "$0")

# Install additional packages
. $WORK_DIR/install-google-chrome.sh
. $WORK_DIR/install-stow.sh
. $WORK_DIR/install-jetbrains-toolbox.sh
. $WORK_DIR/install-slack.sh
. $WORK_DIR/install-screamingfrogseospider.sh
. $WORK_DIR/install-rsync.sh

