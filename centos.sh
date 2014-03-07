#!/bin/bash

USER="sondh"
EMAIL="server@daohoangson.com"

yum update -y

yum install logwatch -y
yum install postfix -y
read -p "Opening logwatch config now. Prepare to change MailTo and MailFrom..."
vi /usr/share/logwatch/default.conf/logwatch.conf
echo "Running logwatch. You should receive an email like 'Logwatch for $HOSTNAME'..."
/usr/sbin/logwatch
read -p "Opening crontab now. Prepare to add '29 6 * * * /usr/sbin/logwatch'..."
crontab -e

useradd $USER
passwd $USER
mkdir /home/$USER
mkdir /home/$USER/.ssh
chmod 700 /home/$USER/.ssh
read -p "Openning authorized_keys now, ready to paste your .pub content"
vi /home/$USER/.ssh/authorized_keys
chmod 400 /home/$USER/.ssh/authorized_keys
chown $USER:$USER /home/$USER -R
read -p "Insert '$USER ALL=(ALL) ALL' to grant sudo"
visudo

read -p "Opening sshd config now, you should: 1, change port; 2, PasswordAuthentication no; 3, PermitRootLogin no"
vi /etc/ssh/sshd_config
service sshd restart
echo "Restarted sshd, please try ssh into the server with $USER account before ending this SSH session"
