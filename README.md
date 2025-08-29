# Linux Configuration

This repository contains configuration files for automating the setup of various Linux distributions.

## Current Setup

The initial configuration is for **Linux Mint**. It uses a preseed file (`mint/install.seed`) to automate the installation process. A `late-command.sh` script is executed at the end of the installation to install additional applications:

- Google Chrome
- JetBrains Toolbox
- GitHub CLI
- Kitty terminal (with Dracula theme)
- Neovim (with LazyVim)

## Linux Mint Installation Guide

To set up Linux Mint using this repository's preseed configuration, follow these steps during the installation process:

1.  **Boot from Linux Mint Installation Media:** Start your computer from the Linux Mint live USB or DVD.
2.  **Access the Boot Menu:** When the GRUB boot menu appears, select the "Start Linux Mint" option (or similar) and press `e` to edit the boot parameters.
3.  **Add Preseed URL:** Locate the line that typically starts with `linux /boot/vmlinuz-...` and append the following to the end of that line, ensuring there's a space before it:
    ```
    auto=true url=https://linux.josht.com/mint/install.seed
    ```
    This tells the installer to automatically use the preseed file located at the specified URL.
4.  **Boot and Install:** Press `F10` or `Ctrl+X` to boot with the modified parameters. The installer should now proceed automatically, using the `install.seed` file to configure the system and execute the `late-command.sh` script for additional software installations.

## Future Expansion

The repository is structured to be easily expandable for other distributions in the future. Potential additions could include:

- **Debian/Ubuntu:** The current `install.seed` could be adapted for other Debian-based distributions.
- **Other Distributions:** Configurations for other distributions like Fedora, Arch Linux, or others could be added in separate directories.
