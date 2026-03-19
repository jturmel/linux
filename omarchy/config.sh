#!/usr/bin/env bash
# Register all configuration - sourced by setup.sh
# This file registers config hooks without executing them

WORK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Configure Docker containers
# shellcheck source=config-docker-containers.sh
source "$WORK_DIR/config-docker-containers.sh"
