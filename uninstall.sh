#!/bin/bash
PATH_RULE="/etc/NetworkManager/dispatcher.d/pre-up.d"
PATH_EXEC="/usr/local/bin"

echo "NoNetwork script uninstall"
sudo groupdel noinet
sudo groupdel nolan

sudo rm $PATH_RULE/noinet_rule $PATH_RULE/nolan_rule
sudo rm $PATH_EXEC/noinet $PATH_EXEC/nolan