#!/usr/bin/env bash
# Register Python development environment
# Uses post-install hook for dev env setup

register_post_install_hook '
    if command -v mise &>/dev/null && mise current python &>/dev/null && command -v uv &>/dev/null; then
        log_info "Python dev-env already configured with mise and uv, skipping"
    else
        omarchy install dev-env python
    fi
'
