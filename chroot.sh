#!/bin/sh
clear

# edit /etc/pacman.conf file
nano /etc/pacman.conf

clear

# timezone
ln -sf /usr/share/zoneinfo/Europe/Istanbul /etc/localtime
hwclock --systohc

clear

read -p "Select locale [en/tr]: " localeset

if [ $localeset == "en" ];
then
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
    locale-gen
    touch /etc/locale.conf
    echo "LANG=en_US.UTF-8"
    touch /etc/vconsole.conf
    echo "KEYMAP=us" >> /etc/vconsole.conf
else
    echo "tr_TR.UTF-8 UTF-8" >> /etc/locale.gen
    locale-gen
    touch /etc/locale.conf
    echo "LANG=tr_TR.UTF-8"
    touch /etc/vconsole.conf
    echo "KEYMAP=trq" >> /etc/vconsole.conf
fi

clear

# host
read -p 'Hostname: ' host_name
echo $host_name >> /etc/hostname

echo '127.0.0.1       localhost' >> /etc/hosts
echo '::1             localhost' >> /etc/hosts
echo '127.0.1.1       '$host_name'.localdomain     '$host_name >> /etc/hosts

clear

# root password
echo 'Root password'
passwd

clear

# packages
pacman -Sy networkmanager
systemctl enable NetworkManager
sleep 2
clear

# touchpad support
pacman -S xf86-input-libinput xf86-input-elographics xf86-input-evdev xf86-input-synaptics xf86-input-void xf86-input-wacom
clear

# NTFS filesystem support
pacman -S ntfs-3g
clear

# Video drivers
pacman -S mesa lib32-mesa opencl-mesa lib32-opencl-mesa vulkan-radeon lib32-vulkan-radeon amd-ucode intel-ucode xf86-video-intel xf86-video-amdgpu libva-intel-driver vulkan-intel lib32-libva-intel-driver libva-mesa-driver lib32-libva-mesa-driver

clear

# Desktop Environment
pacman -S xorg xorg-xinit gnome gnome-tweaks
systemctl enable gdm
clear

# GRUB
pacman -S grub
clear

lsblk
read -p "Select disk for GRUB installation (Example: vda, sda, nvme0n1): " grub_disk

grub-install --target=i386-pc /dev/$grub_disk
sleep 1
clear

grub-mkconfig -o /boot/grub/grub.cfg
sleep 3
clear

# useradd
read -p 'Username: ' user_name
clear
useradd -m -g users -G wheel,storage,power,audio,video,network -s /bin/bash $user_name
echo $user_name 'password'
passwd $user_name

# sudo privileges
EDITOR=nano visudo
clear
