#!/bin/bash
 bash /usr/local/bin/TorNet/scripts/vpn/vpngate_stop.sh
iptables-save >iptables.rules

iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 53
iptables -t nat -A OUTPUT -p tcp --dport 53 -j REDIRECT --to-ports 53

echo "" | tee /usr/local/bin/TorNet/tmp/vpn.log

# killall tor
nmcli connection import type openvpn file /usr/local/bin/TorNet/source/TorNet.ovpn 
nmcli connection up TorNet | tee /usr/local/bin/TorNet/tmp/vpn.log

systemctl restart cloudflared-proxy-dns.service 
exit 0
