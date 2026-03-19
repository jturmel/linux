#!/usr/bin/env bash
# Shared setup library for Omarchy
# Provides orchestration, logging, and package registration

set -euo pipefail

# Script directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="${SCRIPT_DIR}"

# Mode flags
DRY_RUN=false
VERBOSE=false
SETUP_FAILED=0

# Package registries
declare -a PACMAN_PACKAGES=()
declare -a YAY_PACKAGES=()
declare -a FLATPAK_PACKAGES=()
declare -a REMOVE_COMMANDS=()
declare -a POST_INSTALL_HOOKS=()
declare -a POST_CONFIG_HOOKS=()

# Status tracking
declare -a COMPLETED_ITEMS=()
declare -a SKIPPED_ITEMS=()
declare -a FAILED_ITEMS=()
declare -a MANUAL_FOLLOWUP_ITEMS=()

# Logging functions
log_info() {
    echo "[INFO] $1"
}

log_warn() {
    echo "[WARN] $1"
}

log_error() {
    echo "[ERROR] $1" >&2
}

log_success() {
    echo "[OK] $1"
}

log_debug() {
    if [[ "$VERBOSE" == true ]]; then
        echo "[DEBUG] $1"
    fi
}

# Check if running in dry-run mode
is_dry_run() {
    [[ "$DRY_RUN" == true ]]
}

# Register packages for batch installation
register_pacman() {
    for pkg in "$@"; do
        PACMAN_PACKAGES+=("$pkg")
    done
}

register_yay() {
    for pkg in "$@"; do
        YAY_PACKAGES+=("$pkg")
    done
}

register_flatpak() {
    for pkg in "$@"; do
        FLATPAK_PACKAGES+=("$pkg")
    done
}

# Register removal commands
register_remove_cmd() {
    REMOVE_COMMANDS+=("$*")
}

# Register hooks
register_post_install_hook() {
    POST_INSTALL_HOOKS+=("$1")
}

register_post_config_hook() {
    POST_CONFIG_HOOKS+=("$1")
}

# Record results
record_completed() {
    COMPLETED_ITEMS+=("$1")
}

record_skipped() {
    SKIPPED_ITEMS+=("$1")
}

record_failed() {
    FAILED_ITEMS+=("$1")
    SETUP_FAILED=1
}

record_manual_followup() {
    MANUAL_FOLLOWUP_ITEMS+=("$1")
}

# Deduplicate package arrays
deduplicate_packages() {
    local -n arr=$1
    local -a unique
    local seen
    
    for item in "${arr[@]}"; do
        seen=false
        for existing in "${unique[@]}"; do
            if [[ "$item" == "$existing" ]]; then
                seen=true
                break
            fi
        done
        if [[ "$seen" == false ]]; then
            unique+=("$item")
        fi
    done
    
    arr=("${unique[@]}")
}

# Sudo management
SUDO_KEEPALIVE_PID=""

warmup_sudo() {
    log_info "Warming up sudo credentials..."
    if is_dry_run; then
        log_info "[DRY-RUN] Would prompt for sudo"
        return 0
    fi
    
    sudo -v
    
    # Keep sudo alive in background
    (
        while true; do
            sudo -n true 2>/dev/null || break
            sleep 50
        done
    ) &
    SUDO_KEEPALIVE_PID=$!
}

cleanup_sudo_keepalive() {
    if [[ -n "$SUDO_KEEPALIVE_PID" ]] && kill -0 "$SUDO_KEEPALIVE_PID" 2>/dev/null; then
        kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
    fi
}

# Preflight checks
run_preflight() {
    log_info "Running preflight checks..."
    
    # Check for required tools
    if ! command -v bash &>/dev/null; then
        log_error "bash is required but not found"
        return 1
    fi
    
    if ! command -v yay &>/dev/null; then
        log_warn "yay not found in PATH - AUR packages will be skipped"
    fi
    
    # Check network connectivity
    if ! curl -s --max-time 5 https://archlinux.org &>/dev/null; then
        log_warn "Network connectivity check failed - package installs may fail"
    fi
    
    # Warm up sudo
    warmup_sudo
    
    record_completed "preflight checks"
}

# Execute removal commands
run_remove_stage() {
    log_info "=== Remove Stage ==="
    
    if [[ ${#REMOVE_COMMANDS[@]} -eq 0 ]]; then
        log_info "No removals scheduled"
        return 0
    fi
    
    local cmd
    for cmd in "${REMOVE_COMMANDS[@]}"; do
        log_info "Removing: $cmd"
        if is_dry_run; then
            log_info "[DRY-RUN] Would run: $cmd"
            record_completed "remove: $cmd"
            continue
        fi
        
        # shellcheck disable=SC2086
        if eval "$cmd" 2>/dev/null; then
            record_completed "remove: $cmd"
        else
            log_warn "Failed to remove (may not exist): $cmd"
            record_skipped "remove: $cmd (not found)"
        fi
    done
}

# Batch package installation
run_install_stage() {
    log_info "=== Install Stage ==="
    
    # Deduplicate packages
    deduplicate_packages PACMAN_PACKAGES
    deduplicate_packages YAY_PACKAGES
    deduplicate_packages FLATPAK_PACKAGES
    
    # Install pacman packages
    if [[ ${#PACMAN_PACKAGES[@]} -gt 0 ]]; then
        log_info "Installing ${#PACMAN_PACKAGES[@]} pacman package(s)..."
        if is_dry_run; then
            log_info "[DRY-RUN] Would run: sudo pacman -S --needed --noconfirm ${PACMAN_PACKAGES[*]}"
        else
            if sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"; then
                record_completed "pacman packages: ${PACMAN_PACKAGES[*]}"
            else
                log_error "Failed to install some pacman packages"
                record_failed "pacman packages"
            fi
        fi
    fi
    
    # Install yay packages
    if [[ ${#YAY_PACKAGES[@]} -gt 0 ]]; then
        if command -v yay &>/dev/null; then
            log_info "Installing ${#YAY_PACKAGES[@]} yay package(s)..."
            if is_dry_run; then
                log_info "[DRY-RUN] Would run: yay -S --needed --noconfirm ${YAY_PACKAGES[*]}"
            else
                if yay -S --needed --noconfirm "${YAY_PACKAGES[@]}"; then
                    record_completed "yay packages: ${YAY_PACKAGES[*]}"
                else
                    log_error "Failed to install some yay packages"
                    record_failed "yay packages"
                fi
            fi
        else
            log_warn "yay not available, skipping ${#YAY_PACKAGES[@]} AUR package(s)"
            record_skipped "yay packages (yay not installed)"
        fi
    fi
    
    # Install flatpak packages
    if [[ ${#FLATPAK_PACKAGES[@]} -gt 0 ]]; then
        if command -v flatpak &>/dev/null; then
            log_info "Installing ${#FLATPAK_PACKAGES[@]} flatpak package(s)..."
            for pkg in "${FLATPAK_PACKAGES[@]}"; do
                if is_dry_run; then
                    log_info "[DRY-RUN] Would run: flatpak install --noninteractive flathub $pkg"
                else
                    if flatpak install --noninteractive flathub "$pkg" 2>/dev/null; then
                        record_completed "flatpak: $pkg"
                    else
                        log_warn "Failed to install flatpak package: $pkg"
                        record_failed "flatpak: $pkg"
                    fi
                fi
            done
        else
            log_warn "flatpak not available, skipping ${#FLATPAK_PACKAGES[@]} flatpak package(s)"
            record_skipped "flatpak packages (flatpak not installed)"
        fi
    fi
    
    # Run post-install hooks
    if [[ ${#POST_INSTALL_HOOKS[@]} -gt 0 ]]; then
        log_info "Running ${#POST_INSTALL_HOOKS[@]} post-install hook(s)..."
        local hook
        for hook in "${POST_INSTALL_HOOKS[@]}"; do
            log_info "Running hook: $hook"
            if is_dry_run; then
                log_info "[DRY-RUN] Would run hook: $hook"
                record_completed "hook: $hook"
            else
                if eval "$hook"; then
                    record_completed "hook: $hook"
                else
                    log_error "Hook failed: $hook"
                    record_failed "hook: $hook"
                fi
            fi
        done
    fi
}

# Configuration stage
run_config_stage() {
    log_info "=== Config Stage ==="
    
    # Run post-config hooks
    if [[ ${#POST_CONFIG_HOOKS[@]} -gt 0 ]]; then
        log_info "Running ${#POST_CONFIG_HOOKS[@]} post-config hook(s)..."
        local hook
        for hook in "${POST_CONFIG_HOOKS[@]}"; do
            log_info "Running config hook: $hook"
            if is_dry_run; then
                log_info "[DRY-RUN] Would run config hook: $hook"
                record_completed "config hook: $hook"
            else
                if eval "$hook"; then
                    record_completed "config hook: $hook"
                else
                    log_error "Config hook failed: $hook"
                    record_failed "config hook: $hook"
                fi
            fi
        done
    fi
}

# Print final recap
print_recap() {
    log_info ""
    log_info "=== Setup Complete ==="
    log_info ""
    
    if [[ ${#COMPLETED_ITEMS[@]} -gt 0 ]]; then
        echo "Completed (${#COMPLETED_ITEMS[@]} items):"
        for item in "${COMPLETED_ITEMS[@]}"; do
            echo "  ✓ $item"
        done
        echo ""
    fi
    
    if [[ ${#SKIPPED_ITEMS[@]} -gt 0 ]]; then
        echo "Skipped (${#SKIPPED_ITEMS[@]} items):"
        for item in "${SKIPPED_ITEMS[@]}"; do
            echo "  ⊘ $item"
        done
        echo ""
    fi
    
    if [[ ${#FAILED_ITEMS[@]} -gt 0 ]]; then
        echo "Failed (${#FAILED_ITEMS[@]} items):"
        for item in "${FAILED_ITEMS[@]}"; do
            echo "  ✗ $item"
        done
        echo ""
    fi
    
    if [[ ${#MANUAL_FOLLOWUP_ITEMS[@]} -gt 0 ]]; then
        echo "Manual follow-up required (${#MANUAL_FOLLOWUP_ITEMS[@]} items):"
        for item in "${MANUAL_FOLLOWUP_ITEMS[@]}"; do
            echo "  → $item"
        done
        echo ""
    fi
    
    if [[ $SETUP_FAILED -eq 0 ]]; then
        log_success "Setup completed successfully!"
    else
        log_warn "Setup completed with some issues (see above)"
        return 1
    fi
}

# Cleanup on exit
cleanup() {
    cleanup_sudo_keepalive
}

trap cleanup EXIT

# Export functions for use in sourced scripts
export -f log_info log_warn log_error log_success log_debug
export -f is_dry_run
export -f register_pacman register_yay register_flatpak
export -f register_remove_cmd
export -f register_post_install_hook register_post_config_hook
export -f record_completed record_skipped record_failed record_manual_followup
