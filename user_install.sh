#!/bin/bash

aur_packages=(
    chromium-pepper-flash
    i3blocks
    j4-dmenu-desktop
    numix-circle-icon-theme-git
    numix-frost-themes
    numix-icon-theme-git
    powerline-fonts-git
    sublime-text-dev
    ttf-font-awesome
)

arch_aur_manager() {
    sed -i 's/^#keyserver-options auto-key-retrieve/keyserver-options auto-key-retrieve/' ~/.gnupg/gpg.conf

    #Install cower (pacaur's dependency)
    wget -P /tmp https://aur.archlinux.org/cgit/aur.git/snapshot/cower.tar.gz
    tar -xvf /tmp/cower.tar.gz -C /tmp
    cd /tmp/cower
    makepkg -si --noconfirm

    #Install pacaur
    wget -P /tmp https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz
    tar -xvf /tmp/pacaur.tar.gz -C /tmp
    cd /tmp/pacaur
    makepkg -si --noconfirm
}

arch_aur_packages_install() {
    pacaur -S --noconfirm ${aur_packages[*]}
}

arch_oh_my_zsh_install() {
    cd /tmp

    wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh

    #Change default shell
    chsh -s $(which zsh)
}

arch_user_stow() {
    if [[ -e "/home/$USER/.zshrc" ]]; then
        rm -f /home/$USER/.zshrc
    fi

    mkdir -p ~/.config/dunst
    mkdir -p ~/.config/gtk-3.0
    mkdir -p ~/.config/livestreamer
    mkdir -p ~/.config/ranger
    mkdir -p ~/.i3/scripts
    mkdir -p ~/.mplayer
    mkdir -p ~/.vim/bundle/neobundle.vim

    cd ~/.dotfiles
    stow dunst -t ~
    stow gtk2 -t ~
    stow gtk3 -t ~
    stow ideavim -t ~
    stow i3 -t ~
    stow livestreamer -t ~
    stow mplayer -t ~
    stow pentadactyl -t ~
    stow pynote -t ~
    stow ranger -t ~
    stow vim -t ~
    stow Xorg -t ~
    stow zsh -t ~
}

arch_vim() {
    mkdir -p ~/.cache/vim
}

arch_pip_install() {
    #Test if pip command exists.
    hash pip &> /dev/null
    if [[ $? -ne 0 ]]; then
        wget -P /tmp https://bootstrap.pypa.io/get-pip.py
        sudo python2 /tmp/get-pip.py
        sudo python3 /tmp/get-pip.py
    fi
}

arch_aur_manager
arch_aur_packages_install
arch_oh_my_zsh_install
arch_user_stow
arch_vim
arch_pip_install
