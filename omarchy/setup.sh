#!/usr/bin/env bash
# Omarchy setup orchestrator
# Runs everything with minimal prompts, batches package installs, and prints a final recap

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="${SCRIPT_DIR}"

# Source the shared library
# shellcheck source=setup-lib.sh
source "$WORK_DIR/setup-lib.sh"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        --help|-h)
            echo "Usage: $(basename "$0") [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --dry-run     Show what would be installed without making changes"
            echo "  --verbose     Show detailed debug output"
            echo "  --help        Show this help message"
            echo ""
            echo "Runs the full Omarchy setup flow:"
            echo "  1. Preflight checks and sudo warmup"
            echo "  2. Remove unwanted packages"
            echo "  3. Install all packages (batched)"
            echo "  4. Run configuration hooks"
            echo "  5. Print final recap"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

if is_dry_run; then
    log_info "=== DRY RUN MODE ==="
    log_info "No changes will be made to your system"
    log_info ""
fi

# Stage 1: Preflight
log_info "Starting Omarchy setup..."
run_preflight

# Stage 2: Load registrations
log_info "Loading package and hook registrations..."

# Load removals first (so they happen before installs)
# shellcheck source=remove.sh
source "$WORK_DIR/remove.sh"

# Load installations
# shellcheck source=install.sh
source "$WORK_DIR/install.sh"

# Load configuration
# shellcheck source=config.sh
source "$WORK_DIR/config.sh"

# Stage 3: Execute removals
run_remove_stage

# Stage 4: Execute installs (batched)
run_install_stage

# Stage 5: Execute config
run_config_stage

# Stage 6: Print recap
print_recap

exit $SETUP_FAILED
