ROOTSIZE=""
SWAPSIZE=""
PACKAGES=""
TIMEZONE=""
LOCALE=""
KEYMAP=""
HOSTNAME=""
ROOT=""
USER=""

read -p "Taille de la partition root en M: " ROOTSIZE
read -p "Taille de la partition swap en M: " SWAPSIZE
read -p "Packets à installer: " PACKAGES
read -p "Timezone :" TIMEZONE
read -p "Locale :" LOCALE
read -p "Keymap de la console :" KEYMAP
read -p "Hostname :" HOSTNAME
read -p "Mot de passe de l'admin :" ROOT
read -p "Utilisateurs et mots de passe :" USER

loadkeys fr-latin1
ip link
timedatectl set-ntp true

echo -e "o\nn\np\n\n\n+${ROOTSIZE}M\nw" | fdisk /dev/sda
echo -e "n\np\n\n\n+${SWAPSIZE}M\nt\n\n82\nw" | fdisk /dev/sda

mkfs.ext4 /dev/sda1
mkswap /dev/sda2

mount /dev/sda1 /mnt
swapon /dev/sda2

echo -e "y" | pacstrap /mnt ${PACKAGES[@]}

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
hwclock --systohc


echo "LANG=$LOCALE" > /etc/locale.conf
touch vconsole.conf
echo "KEYMAP=$KEYMAP" >> /etc/vconsole.conf
echo "$HOSTNAME" > /etc/hostname

echo -e "${ROOT}\n${ROOT} | passwd

USERS=(${USER})
for (( index = 0; index <= ${#USERS[@]} - 2; index+=2 ))
do
 NEXT=$(($index+1))
 useradd ${USERS[$index]} -p ${USERS[$NEXT]}
done

exit
umount -R /mnt
reboot

#LOCALE=en_US.UTF-8
#KEYMAP=fr-latin1
#TIMEZONE=Europe/Paris
