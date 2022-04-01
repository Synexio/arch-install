#! /bin/sh

read -p "Taille de la partition root en M: " ROOTSIZE
read -p "Taille de la partition swap en M: " SWAPSIZE
read -p "Packets à installer: " PACKAGES
read -p "Timezone :" TIMEZONE
read -p "Locale :" LOCALE
read -p "Keymap de la console :" KEYMAP
read -p "Hostname :" HOSTNAME
read -p "Mot de passe de l'admin :" ROOT
read -p "Utilisateurs et mots de passe :" USER

ip link
timedatectl set-ntp true

echo -e "o\nn\np\n\n\n+${ROOTSIZE}M\nw" | fdisk /dev/sda
echo -e "n\np\n\n\n+${SWAPSIZE}M\nt\n\n82\nw" | fdisk /dev/sda

mkfs.ext4 /dev/sda1
mkswap /dev/sda2

mount /dev/sda1 /mnt
swapon /dev/sda2
