#!/usr/bin/env bash
# Register all installations - sourced by setup.sh
# This file registers packages and hooks without executing them

WORK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install additional packages
# shellcheck source=install-ai-codex.sh
source "$WORK_DIR/install-ai-codex.sh"
# shellcheck source=install-ai-lmstudio.sh
source "$WORK_DIR/install-ai-lmstudio.sh"
# shellcheck source=install-ack.sh
source "$WORK_DIR/install-ack.sh"
# shellcheck source=install-bind-tools.sh
source "$WORK_DIR/install-bind-tools.sh"
# shellcheck source=install-dracula-theme.sh
source "$WORK_DIR/install-dracula-theme.sh"
# shellcheck source=install-dev-env-python.sh
source "$WORK_DIR/install-dev-env-python.sh"
# shellcheck source=install-dev-env-go.sh
source "$WORK_DIR/install-dev-env-go.sh"
# shellcheck source=install-dev-env-rust.sh
source "$WORK_DIR/install-dev-env-rust.sh"
# shellcheck source=install-discord.sh
source "$WORK_DIR/install-discord.sh"
# shellcheck source=install-fvm.sh
source "$WORK_DIR/install-fvm.sh"
# shellcheck source=install-gemini-cli.sh
source "$WORK_DIR/install-gemini-cli.sh"
# shellcheck source=install-google-chrome.sh
source "$WORK_DIR/install-google-chrome.sh"
# shellcheck source=install-google-cloud.sh
source "$WORK_DIR/install-google-cloud.sh"
# shellcheck source=install-jetbrains-toolbox.sh
source "$WORK_DIR/install-jetbrains-toolbox.sh"
# shellcheck source=install-kitty.sh
source "$WORK_DIR/install-kitty.sh"
# shellcheck source=install-local-by-flywheel.sh
source "$WORK_DIR/install-local-by-flywheel.sh"
# shellcheck source=install-oh-my-posh.sh
source "$WORK_DIR/install-oh-my-posh.sh"
# shellcheck source=install-pix.sh
source "$WORK_DIR/install-pix.sh"
# shellcheck source=install-rsync.sh
source "$WORK_DIR/install-rsync.sh"
# shellcheck source=install-screamingfrogseospider.sh
source "$WORK_DIR/install-screamingfrogseospider.sh"
# shellcheck source=install-slack.sh
source "$WORK_DIR/install-slack.sh"
# shellcheck source=install-stow.sh
source "$WORK_DIR/install-stow.sh"
# shellcheck source=install-tailscale.sh
source "$WORK_DIR/install-tailscale.sh"
# shellcheck source=install-terraform.sh
source "$WORK_DIR/install-terraform.sh"
# shellcheck source=install-waybar-basecamp.sh
source "$WORK_DIR/install-waybar-basecamp.sh"
# shellcheck source=install-yazi.sh
source "$WORK_DIR/install-yazi.sh"
# shellcheck source=install-zsh.sh
source "$WORK_DIR/install-zsh.sh"
# shellcheck source=install-go-task.sh
source "$WORK_DIR/install-go-task.sh"
