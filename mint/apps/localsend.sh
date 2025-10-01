#!/bin/bash

# Fetch the latest release information from GitHub API
RELEASE_INFO=$(curl -s https://api.github.com/repos/localsend/localsend/releases/latest)

# Extract the download URL for the .deb file
# This assumes a naming convention like "LocalSend-*-linux-x86-64.deb"
DOWNLOAD_URL=$(echo "$RELEASE_INFO" | grep -oP '"browser_download_url": "\K[^"]*LocalSend-.*-linux-x86-64\.deb' | head -n 1)

if [ -z "$DOWNLOAD_URL" ]; then
  echo "Error: Could not find the latest .deb download URL."
  exit 1
fi

# Extract the version number from the URL for informational purposes
VERSION=$(echo "$DOWNLOAD_URL" | grep -oP 'LocalSend-\K[0-9]+\.[0-9]+\.[0-9]+')

echo "Found LocalSend version: $VERSION"

# Download the .deb file and save it as localsend.deb
wget -qO localsend.deb "$DOWNLOAD_URL"

if [ $? -eq 0 ]; then
  echo "LocalSend .deb file downloaded successfully as localsend.deb"
else
  echo "Error: Failed to download localsend.deb"
  exit 1
fi

sudo dpkg -i localsend.deb

rm localsend.deb
