#!/bin/bash

iptables-restore  <iptables.rules
nmcli connection down server
nmcli connection delete server
systemctl restart NetworkManager
systemctl restart cloudflared-proxy-dns


echo "" | tee /usr/local/bin/TorNet/tmp/vpn.log

exit 0
