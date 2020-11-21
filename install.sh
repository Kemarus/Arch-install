#!/bin/bash

#Rank mirrors by speed. Takes a while.
arch_rankmirrors() {
    echo "Ranking mirrors. May take a while."
    cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
    rankmirrors /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist

    #Refresh package lists
    pacman -Syy

    echo "Mirrors ranked."
}

arch_partition(){
    #Create Partition table
    parted /dev/sda -s "mklabel msdos"

    #Partition schemes
    parted /dev/sda -s "mkpart primary linux-swap 0% 512MiB"
    parted /dev/sda -s "mkpart primary btrfs 512MiB 100%"
    parted /dev/sda -s "set 2 boot on"

    #Create filesystems
    mkfs.btrfs /dev/sda2

    #Activate swap
    mkswap /dev/sda1
    swapon /dev/sda1

    #Partition mounting
    mount /dev/sda2 /mnt

    echo "Storage devices prepared."
}

arch_install() {
    #Install base system
    pacstrap /mnt base base-devel btrfs-progs

    #Generate fstab
    genfstab -U -p /mnt >> /mnt/etc/fstab

    #arch-chroot /mnt /bin/bash -si << ENDCMD
#ENDCMD
    cp chroot_install.sh /mnt/root
    cp user_install.sh /mnt/root
    arch-chroot /mnt /root/chroot_install.sh

    echo "Base system installed"
    echo "Unmount /mnt (umount -R /mnt), then reboot"
}

arch_clean() {
    rm /mnt/root/chroot_install.sh
}


arch_rankmirrors
arch_partition
arch_install
arch_clean
