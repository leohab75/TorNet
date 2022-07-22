#!/bin/bash

iptables -t nat -F

killall openvpn 2 &>/dev/null
killall openvpn 2 &>/dev/null

systemctl restart NetworkManager
echo "nameserver 127.0.0.1" | sudo tee /etc/resolv.conf 1&>/dev/null
systemctl restart cloudflared-proxy-dns

killall openvpn 2 &>/dev/null

#finish
exit 0
