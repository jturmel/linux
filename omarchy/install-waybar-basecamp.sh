#!/usr/bin/env bash
# Register Waybar Basecamp for installation
# Uses post-install hook for remote installation

register_post_install_hook "curl -sL https://github.com/jturmel/waybar-basecamp/releases/latest/download/install.sh | bash"
