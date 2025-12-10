#!/usr/bin/env bash

INSTALL_DIR="$HOME/.local/share/bin"
BINARY_NAME="basecamp-notifier"
REPO_URL="https://github.com/kmorey/waybar-basecamp-notifier/releases/latest/download/$BINARY_NAME"

if [ ! -d "$INSTALL_DIR" ]; then
    echo "Creating directory: $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"
fi

echo "Downloading latest release to $INSTALL_DIR/$BINARY_NAME..."
curl -L -f -o "$INSTALL_DIR/$BINARY_NAME" "$REPO_URL"

if [ $? -eq 0 ]; then
    chmod +x "$INSTALL_DIR/$BINARY_NAME"
    echo "Success! $BINARY_NAME has been installed to $INSTALL_DIR"
else
    echo "Error: Failed to download. The asset name might have changed in the latest release."
fi

