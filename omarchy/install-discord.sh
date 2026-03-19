#!/usr/bin/env bash
# Register Discord (Flatpak) for installation
# Uses post-install hook for flatpak setup

register_pacman flatpak

# Register post-install hook for Discord setup
register_post_install_hook '
    log_info "Setting up Flatpak and installing Discord..."

    # Ensure flathub remote exists
    if ! flatpak remotes | grep -q flathub; then
        if flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo; then
            record_completed "flathub remote"
        else
            record_failed "flathub remote setup"
            record_manual_followup "Add flathub manually: flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo"
            exit 1
        fi
    fi

    # Install Discord
    if flatpak list | grep -q com.discordapp.Discord; then
        log_info "Discord already installed via Flatpak"
        record_completed "discord (already present)"
    else
        if flatpak install --noninteractive flathub com.discordapp.Discord 2>/dev/null; then
            record_completed "discord"
        else
            record_failed "discord installation"
            record_manual_followup "Install Discord manually: flatpak install flathub com.discordapp.Discord"
        fi
    fi
'
