#!/bin/sh
clear

# edit /etc/pacman.conf file
nano /etc/pacman.conf

# update mirrors
pacman -Sy archlinux-keyring

# real-time synchronize
timedatectl set-ntp true

clear

# disk configuration
lsblk
echo ' '
read -p 'Select Disk (Example: vda, sda, nvme0n1): ' disk_selection
cfdisk /dev/$disk_selection

clear
lsblk
echo ' '

# format disk label
read -p 'Select Root partition (Example: vda1, sda1, nvme0n1p1): ' root_partition
mkfs.ext4 /dev/$root_partition
mount /dev/$root_partition /mnt

clear

# install base packages
pacstrap /mnt base base-devel linux linux-headers linux-firmware git nano

# create fstab file
genfstab -U /mnt > /mnt/etc/fstab

cp $(pwd)/chroot.sh /mnt
arch-chroot /mnt /bin/bash
rm -rf /mnt/chroot.sh
