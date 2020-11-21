# Arch install

## Introduction
These script automate Arch Linux installation.

## Branches
- `desktop`: TODO
- `virtual_machine`: intended to use in a virtual_machine, for testing purposes.

## Usage
- `loadkeys $LAYOUT`: change keyboard layout if necessary.
- `pacman -Sy git`: install git.
- `git clone https://github.com/Kemarus/Arch-install.git`: clone this repository.
- `git checkout BRANCH`: where `BRANCH` is the desired branch.
- `cd Arch-install && ./install.sh`: run the script.
- When installation is finished, unmount with `umount -R /mnt` and reboot.
- Run `user_install.sh` (in the home directory).
