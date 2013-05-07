#!/bin/bash

USER="sondh"
EMAIL="server@daohoangson.com"

apt-get update
apt-get upgrade
apt-get install fail2ban

useradd $USER
read -p "Prepare to enter password for $USER..."
passwd $USER
mkdir /home/$USER
mkdir /home/$USER/.ssh
chmod 700 /home/$USER/.ssh
read -p "Openning authorized_keys now, ready to paste your .pub content"
vi /home/$USER/.ssh/authorized_keys
chmod 400 /home/$USER/.ssh/authorized_keys
chown $USER:$USER /home/$USER -R
read -p "Insert `$USER ALL=(ALL) ALL` to grant sudo"
visudo

apt-get install unattended-upgrades
echo 'APT::Periodic::Update-Package-Lists "1";' > /etc/apt/apt.conf.d/10periodic
echo 'APT::Periodic::Download-Upgradeable-Packages "1";' >> /etc/apt/apt.conf.d/10periodic
echo 'APT::Periodic::AutocleanInterval "7";' >> /etc/apt/apt.conf.d/10periodic
echo 'APT::Periodic::Unattended-Upgrade "1";' >> /etc/apt/apt.conf.d/10periodic

echo 'Unattended-Upgrade::Allowed-Origins {' > /etc/apt/apt.conf.d/50unattended-upgrades
echo '        "Ubuntu lucid-security";' >> /etc/apt/apt.conf.d/50unattended-upgrades
echo '//      "Ubuntu lucid-updates";' >> /etc/apt/apt.conf.d/50unattended-upgrades
echo '};' >> /etc/apt/apt.conf.d/50unattended-upgrades

apt-get install logwatch
echo '/usr/sbin/logwatch --output mail --mailto $EMAIL --detail high' >> /etc/cron.daily/00logwatch


