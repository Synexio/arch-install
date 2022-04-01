# arch-install

Une fois sur l'iso arch :<br/>

loadkeys fr-latin1<br/>
curl -s https://raw.githubusercontent.com/Synexio/arch-install/main/install.sh > install.sh<br/>
chmod 777 install.sh<br/>
./install.sh<br/>

Taille de la partition root en M: Valeur en MB, ex: "2048"<br/>
Taille de la partition swap en M: Valeur en MB, ex: "512"<br/>
Packets à installer: ex: "nano" (base, grub, linux et linux-firmware sont installés automatiquement) <br/>
Timezone : "Europe/Paris"<br/>
Locale : "en_US.UTF-8"<br/>
Keymap de la console : "fr-latin1"<br/>
Hostname : Hostname, ex: "Alex"<br/>
Mot de passe de l'admin : Passwd, ex: "root"<br/>
Utilisateurs et mots de passe : Users suivis de leur mdp et séparés d'un espace, ex: "Test 1234 Test2 5678"<br/>


Une fois le script terminé, la machine s'éteint.<br/>
Aller dans les paramètres de son hyperviseur et détacher l'iso de la VM avant de la relancer.<br/>
