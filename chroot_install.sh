#!/bin/bash

hostname="virtualbox-arch"

rootPassword="password"
userName="username"
userPassword="password"

basePackages=(
    stow
)

packages=(
    chromium
    cinnamon
    clementine
    eog
    evince
    firefox
    flashplugin
    gnome-disk-utility
    gvim-python3
    i3
    infinality-bundle
    lib32-freetype2-infinality-ultimate
    lightdm
    lightdm-gtk-greeter
    livestreamer
    mplayer
    mpv
    ncdu
    numix-themes
    numlockx
    ranger
    rxvt-unicode
    skype
    thunderbird
    ttf-anonymous-pro
    ttf-ubuntu-font-family-ib
    virtualbox-guest-utils
    vlc
    wget
    zathura-pdf-poppler
    zsh
    zsh-completions
    zsh-syntax-highlighting
)

arch_install() {
    #Uncomment needed localisations
    sed -i '/^#en_US.UTF-8 /s/^#//' /etc/locale.gen
    locale-gen
    echo LANG=en_US.UTF-8 > /etc/locale.conf
    export LANG=en_US.UTF-8

    ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
    hwclock --systohc --utc

    echo $hostname > /etc/hostname
    systemctl enable dhcpcd@"$network".service

    pacman -S --noconfirm grub os-prober
    grub-install --recheck /dev/sda
    grub-mkconfig -o /boot/grub/grub.cfg

    sed -i 's/^# %wheel ALL=(ALL) ALL$/%wheel ALL=(ALL) ALL/g' /etc/sudoers
}

arch_base_packages_dotfiles_install() {
    pacman -S --noconfirm ${basePackages[*]}

    cd /home/$userName
    git clone https://github.com/Kemarus/.dotfiles.git
    cd /home/$userName/.dotfiles
    git checkout virtual_machine

    if [[ -e "/etc/pacman.conf" ]]; then
        rm /etc/pacman.conf
    fi

    stow pacman -t /etc

    #Create /root/.gnupg. Remote key cannot be fetched if it doesn't exist.
    mkdir /root/.gnupg
    #Add infinality-bundle key
    pacman-key -r 962DDE58
    pacman-key -f 962DDE58
    pacman-key --lsign-key 962DDE58
    pacman -Syy
}


arch_packages_install() {
    pacman -S --noconfirm ${packages[*]}
}

arch_user_config() {
    echo "root:$rootPassword" | chpasswd

    useradd -m -G wheel "$userName"
    echo "$userName:$userPassword" | chpasswd

    #Create user's home directories
    mv /root/user_install.sh /home/$userName
}


arch_stow(){
    cd /home/$userName/.dotfiles

    #Remove existing files
    if [[ -e "/etc/vconsole.conf" ]]; then
        rm /etc/vconsole.conf
    fi
    if [[ -e "/etc/lightdm/lightdm-gtk-greeter.conf" ]]; then
        rm /etc/lightdm/lightdm-gtk-greeter.conf
    fi

    #Create directories
    mkdir -p /etc/lightdm
    mkdir -p /etc/X11/xorg.conf.d

    stow etc -t /etc
    cd lightdm/lightdm
    cp lightdm-gtk-greeter.conf lightdm_wallpaper.png zerg.png /etc/lightdm
    cd /home/$userName/.dotfiles
    stow X11 -t /etc
}

arch_services() {
    gpasswd --add $userName vboxsf

    systemctl enable vboxservice
    systemctl enable NetworkManager.service
    systemctl enable lightdm.service
}


arch_install
arch_user_config
arch_base_packages_dotfiles_install
arch_packages_install
arch_stow
arch_services
