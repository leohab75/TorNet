#!/bin/bash

iptables -t nat -F
iptables -t nat -X

iptables-restore  < $HOME/iptables.rules
nmcli connection down TorNet
nmcli connection delete TorNet
systemctl restart NetworkManager
systemctl restart cloudflared-proxy-dns


echo "" | tee /usr/local/bin/TorNet/tmp/vpn.log

exit 0
