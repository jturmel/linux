#!/bin/sh

WORK_DIR=$(dirname "$0")

# Install additional packages
. $WORK_DIR/install-ack.sh
. $WORK_DIR/install-dracula-theme.sh
. $WORK_DIR/install-gemini-cli.sh
. $WORK_DIR/install-google-chrome.sh
. $WORK_DIR/install-google-cloud.sh
. $WORK_DIR/install-jetbrains-toolbox.sh
. $WORK_DIR/install-kitty.sh
. $WORK_DIR/install-oh-my-posh.sh
. $WORK_DIR/install-rsync.sh
. $WORK_DIR/install-screamingfrogseospider.sh
. $WORK_DIR/install-slack.sh
. $WORK_DIR/install-stow.sh
. $WORK_DIR/install-zsh.sh

