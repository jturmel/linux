#!/usr/bin/env bash
# Register all removals - sourced by setup.sh
# This file registers removal commands without executing them

WORK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Remove unwanted packages
# shellcheck source=remove-alacritty.sh
source "$WORK_DIR/remove-alacritty.sh"
# shellcheck source=remove-discord.sh
source "$WORK_DIR/remove-discord.sh"
# shellcheck source=remove-hey.sh
source "$WORK_DIR/remove-hey.sh"
# shellcheck source=remove-omarchy-chromium.sh
source "$WORK_DIR/remove-omarchy-chromium.sh"
# shellcheck source=remove-signal.sh
source "$WORK_DIR/remove-signal.sh"
# shellcheck source=remove-spotify.sh
source "$WORK_DIR/remove-spotify.sh"
