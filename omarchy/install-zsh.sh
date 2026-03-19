#!/usr/bin/env bash
# Register Zsh and related setup
# Uses post-install hook for shell change and Oh My Zsh setup

register_yay zsh zsh-completions

# Register post-install hook for shell setup
register_post_install_hook '
    # Check if zsh is already the default shell
    if [[ "$SHELL" != *"zsh" ]]; then
        log_info "Changing default shell to zsh..."
        if chsh -s "$(which zsh)" 2>/dev/null; then
            record_manual_followup "Log out and back in for shell change to take effect"
        else
            record_manual_followup "Run: chsh -s $(which zsh)"
        fi
    fi

    # Install Oh My Zsh if not present
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log_info "Installing Oh My Zsh..."
        if RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 2>/dev/null; then
            record_completed "oh-my-zsh"
        else
            record_failed "oh-my-zsh installation"
            record_manual_followup "Install Oh My Zsh manually: https://ohmyz.sh"
        fi
    else
        log_info "Oh My Zsh already installed"
        record_completed "oh-my-zsh (already present)"
    fi
'
