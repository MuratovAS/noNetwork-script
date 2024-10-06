#!/bin/bash
PATH_RULE="/etc/NetworkManager/dispatcher.d/pre-up.d"
PATH_EXEC="/usr/local/bin"

echo "NoNetwork script install"

sudo groupadd noinet
sudo groupadd nolan

sudo gpasswd -a $USER noinet
sudo gpasswd -a $USER nolan

#RULE
echo '#!/bin/sh
if [ "$1" = "lo" ]; then
  # rfc3330
  iptables -A OUTPUT -d 240.0.0.0/4 -m owner --gid-owner noinet -j ACCEPT
  iptables -A OUTPUT -d 224.0.0.0/4 -m owner --gid-owner noinet -j ACCEPT
  iptables -A OUTPUT -d 198.18.0.0/15 -m owner --gid-owner noinet -j ACCEPT
  iptables -A OUTPUT -d 192.168.0.0/16 -m owner --gid-owner noinet -j ACCEPT
  iptables -A OUTPUT -d 192.88.99.0/24 -m owner --gid-owner noinet -j ACCEPT
  iptables -A OUTPUT -d 192.0.2.0/24 -m owner --gid-owner noinet -j ACCEPT
  iptables -A OUTPUT -d 172.16.0.0/12 -m owner --gid-owner noinet -j ACCEPT
  iptables -A OUTPUT -d 169.254.0.0/16 -m owner --gid-owner noinet -j ACCEPT
  iptables -A OUTPUT -d 127.0.0.0/8 -m owner --gid-owner noinet -j ACCEPT
  iptables -A OUTPUT -d 10.0.0.0/8 -m owner --gid-owner noinet -j ACCEPT
  iptables -A OUTPUT -m owner --gid-owner noinet -j DROP
fi' | sudo tee $PATH_RULE/noinet_rule
sudo chmod +x $PATH_RULE/noinet_rule

echo '#!/bin/sh
if [ "$1" = "lo" ]; then
  iptables -A OUTPUT -m owner --gid-owner nolan -j DROP
fi' | sudo tee $PATH_RULE/nolan_rule
sudo chmod +x $PATH_RULE/nolan_rule

#EXEC
echo '#!/bin/sh
sg noinet "$*"' | sudo tee $PATH_EXEC/noinet
sudo chmod +x $PATH_EXEC/noinet

echo '#!/bin/sh
sg nolan "$*"' | sudo tee $PATH_EXEC/nolan
sudo chmod +x $PATH_EXEC/nolan

#INIT
sudo $PATH_RULE/noinet_rule lo
sudo $PATH_RULE/nolan_rule lo

#TEST
ping -c 2 1.1.1.1
noinet ping -c 2 1.1.1.1
nolan ping -c 2 127.0.0.1
