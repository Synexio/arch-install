# arch-install

Une fois sur l'iso arch :

loadkeys fr-latin1
curl -s https://raw.githubusercontent.com/Synexio/arch-install/main/install.sh > install.sh
chmod 777 install.sh
./install.sh

Taille de la partition root en M: Valeur en MB, ex: "2048"
Taille de la partition swap en M: Valeur en MB, ex: "512"
Packets à installer:  Base est installé de base, ex: "vim grub NetworkManager" 
Timezone : "Europe/Paris"
Locale : "en_US.UTF-8"
Keymap de la console : "fr-latin1"
Hostname : Hostname, ex: "Alex"
Mot de passe de l'admin : Passwd, ex: "root"
Utilisateurs et mots de passe : Users suivis de leur mdp et séparés d'un espace, ex: "Test 1234 Test2 5678"


Une fois le script terminé, la machine s'éteint.
Aller dans les paramètres de son hyperviseur et détacher l'iso de la VM avant de la relancer.
