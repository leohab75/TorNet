#!/bin/bash

_User_=$(cat /usr/local/bin/TorNet/_User_)

echo "$_User_  ALL=(ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/TorNet_no_passwd

sed -i 's/pkexec/sudo/g' /usr/bin/TorNet
sed -i 's/pkexec/sudo/g' /usr/local/bin/TorNet/scripts/vpn/vpngate_select_gui.sh
sed -i 's/pkexec/sudo/g' /usr/local/bin/TorNet/scripts/vpn/vpngate_favorite.sh

#finish
exit 0