# Arch install

## Introduction
These script automate Arch Linux installation.

## Branches
- `desktop`: TODO
- `virtual_machine`: intended to use in a virtual_machine, for testing purposes.

## Usage
- `loadkeys $LAYOUT`: change keyboard layout if necessary.
- `wget https://github.com/Kemarus/Arch-install/tarball/virtual_machine -O - | tar xz`: clone this repository.
- Go inside the repository.
- `./install.sh`: run the script.
- When installation is finished, unmount with `umount -R /mnt` and reboot.
- Run `user_install.sh` (in the home directory).
