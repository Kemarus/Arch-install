#!/bin/bash

aur_packages=(
    chromium-pepper-flash
    i3blocks
    j4-dmenu-desktop
    keepassx2
    numix-circle-icon-theme-git
    numix-frost-themes
    numix-icon-theme-git
    powerline-fonts-git
    rofi
    rssowl
    sublime-text-dev
    ttf-font-awesome
    tor-browser-en
)

arch_aur_manager() {
    #Install yaourt
    wget -P /tmp https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz
    tar -xvf /tmp/package-query.tar.gz -C /tmp
    cd /tmp/package-query
    makepkg -si --noconfirm

    wget -P /tmp https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz
    tar -xvf /tmp/yaourt.tar.gz -C /tmp
    cd /tmp/yaourt
    makepkg -si --noconfirm

    #Install aura
    wget -P /tmp https://aur.archlinux.org/cgit/aur.git/snapshot/aura-bin.tar.gz
    tar -xvf /tmp/aura-bin.tar.gz -C /tmp
    cd /tmp/aura-bin
    makepkg -si --noconfirm
}

arch_aur_packages_install() {
    sudo aura -A --noconfirm ${aur_packages[*]}
}

arch_oh_my_zsh_install() {
    cd /tmp

    wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh
    wget https://raw.github.com/tonyseek/oh-my-zsh-seeker-theme/master/install.sh -O - | zsh

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
