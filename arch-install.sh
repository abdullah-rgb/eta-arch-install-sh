#!/bin/sh
clear

# edit /etc/pacman.conf file
nano /etc/pacman.conf

# update mirrors
pacman -Sy archlinux-keyring

clear

# disk configuration
lsblk
echo ' '
read -p 'Disk secin (Example: vda, sda, nvme0n1): ' disk_selection
cfdisk /dev/$disk_selection

clear
lsblk
echo ' '

# format disk label
read -p 'Diskinizin Root bolumunu secin (Example: vda1, sda1, nvme0n1p1): ' root_partition
mkfs.ext4 /dev/$root_partition
mount /dev/$root_partition /mnt

read -p 'Diskinizi Boot bolumunu secin (Example: vda1, sda1, nvme0n1p1): ' boot_partition
mkfs.fat -F32 /dev/$boot_partition
mkdir -p /mnt/boot/efi

clear

# install base packages
pacstrap /mnt base base-devel linux linux-headers linux-firmware git nano bc

# create fstab file
genfstab -U /mnt > /mnt/etc/fstab
mount /dev/$boot_partition /mnt/boot/efi

cp $(pwd)/chroot.sh /mnt
arch-chroot /mnt /bin/bash
rm -rf /mnt/chroot.sh
