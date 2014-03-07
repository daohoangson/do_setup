#!/bin/bash

USER="sondh"
EMAIL="server@daohoangson.com"

yum update -y

yum install logwatch -y
yum install postfix -y
read -p "Opening logwatch config now. Prepare to change MailTo and MailFrom..."
vi /usr/share/logwatch/default.conf/logwatch.conf
echo "Running logwatch..."
/usr/sbin/logwatch
read -p "Opening crontab now. Prepare to add '6 29 * * * /usr/sbin/logwatch'..."
crontab -e

rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum install fail2ban -y
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
read -p "Opening fail2ban config now. You may want to disable ssh iptables"
vi /etc/fail2ban/jail.local
service fail2ban restart

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

read -p "Opening sshd config now, you should: 1, change port; 2, PasswordAuthentication no + PubkeyAuthentication yes; 3, PermitRootLogin no"
vi /etc/ssh/sshd_config
service sshd restart
