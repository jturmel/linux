# Linux Configuration

This repository contains configuration files for automating the setup of various Linux distributions.

## Current Setup

The initial configuration is for **Linux Mint**. It uses a preseed file (`mint/install.seed`) to automate the installation process. A `late-command.sh` script is executed at the end of the installation to install additional applications:

- Google Chrome
- JetBrains Toolbox

## Future Expansion

The repository is structured to be easily expandable for other distributions in the future. Potential additions could include:

- **Debian/Ubuntu:** The current `install.seed` could be adapted for other Debian-based distributions.
- **Other Distributions:** Configurations for other distributions like Fedora, Arch Linux, or others could be added in separate directories.
