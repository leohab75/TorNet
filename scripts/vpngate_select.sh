#!/bin/bash
bash /usr/local/bin/TorNet/scripts/vpngate_stop.sh

iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 53
iptables -t nat -A OUTPUT -p tcp --dport 53 -j REDIRECT --to-ports 53

killall tor
openvpn --config /usr/local/bin/TorNet/source/server.ovpn >/usr/local/bin/TorNet/tmp/vpn.log

echo " " | tee /usr/local/bin/TorNet/tmp/vpn.log

#finish
exit 0
