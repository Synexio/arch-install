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

echo -e "y" | mkfs.ext4 /dev/sda1
mkswap /dev/sda2

mount /dev/sda1 /mnt
swapon /dev/sda2

sleep 3s

echo -e "y" | pacstrap /mnt base ${PACKAGES[@]}

genfstab -U /mnt >> /mnt/etc/fstab

sleep 1s

arch-chroot /mnt /bin/bash -c 'ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime'
arch-chroot /mnt /bin/bash -c 'hwclock --systohc'

sleep 1s

arch-chroot /mnt /bin/bash -c 'echo "LANG=$LOCALE" > /etc/locale.conf'
arch-chroot /mnt /bin/bash -c 'touch /etc/vconsole.conf'
arch-chroot /mnt /bin/bash -c 'echo "KEYMAP=$KEYMAP" >> /etc/vconsole.conf'
arch-chroot /mnt /bin/bash -c 'echo "$HOSTNAME" > /etc/hostname'

sleep 1s

arch-chroot /mnt /bin/bash -c 'echo -e "${ROOT}\n${ROOT}" | passwd'

sleep 1s

USERS=(${USER})
for (( index = 0; index <= ${#USERS[@]} - 2; index+=2 ))
do
 NEXT=$(($index+1))
 arch-chroot /mnt /bin/bash -c 'useradd ${USERS[$index]} -p ${USERS[$NEXT]}'
done


sleep 1s

umount -R /mnt

sleep 1s

reboot
