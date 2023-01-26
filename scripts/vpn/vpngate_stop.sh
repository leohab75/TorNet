#!/bin/bash

iptables-restore  <iptables.rules
nmcli connection down TorNet
nmcli connection delete TorNet
systemctl restart NetworkManager
systemctl restart cloudflared-proxy-dns


echo "" | tee /usr/local/bin/TorNet/tmp/vpn.log

exit 0
