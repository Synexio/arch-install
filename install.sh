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

sleep 1s

echo -e "o\nn\np\n\n\n+${ROOTSIZE}M\nw" | fdisk /dev/sda

sleep 1s

echo -e "n\np\n\n\n+${SWAPSIZE}M\nt\n\n82\nw" | fdisk /dev/sda

sleep 1s

echo -e "y" | mkfs.ext4 /dev/sda1

sleep 1s

mkswap /dev/sda2

sleep 1s

mount /dev/sda1 /mnt

sleep 1s

swapon /dev/sda2

sleep 3s

echo -e "y" | pacstrap /mnt base linux linux-firmware grub

sleep 1s

echo -e "y" | pacstrap /mnt ${PACKAGES[@]}

genfstab -U /mnt >> /mnt/etc/fstab

sleep 1s

arch-chroot /mnt /bin/bash -c "ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime"
arch-chroot /mnt /bin/bash -c "hwclock --systohc"

sleep 1s

arch-chroot /mnt /bin/bash -c "locale-gen"
arch-chroot /mnt /bin/bash -c "echo LANG=$LOCALE > /etc/locale.conf"
arch-chroot /mnt /bin/bash -c "touch /etc/vconsole.conf"
arch-chroot /mnt /bin/bash -c "echo KEYMAP=$KEYMAP > /etc/vconsole.conf"
arch-chroot /mnt /bin/bash -c "echo $HOSTNAME > /etc/hostname"

arch-chroot /mnt /bin/bash -c "grub-install --target=i386-pc /dev/sda"

sleep 1s

arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"

sleep 2s

arch-chroot /mnt /bin/bash -c "echo -e \"${ROOT}\n${ROOT}\" | passwd"

sleep 1s

USERS=(${USER})
if (( ${#USERS[@]} >= 2 ))
then
 for (( index = 0; index <= ${#USERS[@]} - 2; index+=2 ))
 do
  NEXT=$(($index+1))
  sleep 1s
  arch-chroot /mnt /bin/bash -c "useradd ${USERS[$index]} -p ${USERS[$NEXT]}"
 done
fi

sleep 1s

umount -R /mnt

sleep 1s

shutdown now
