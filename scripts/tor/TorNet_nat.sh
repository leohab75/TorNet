#!/bin/bash

if [[ ! -f iptables.rules ]]; then
        iptables-save > $HOME/iptables.rules
fi

if [[ "$1" == "start" ]]; then
                
                
        echo -e "start tor via nat route"
        iptables-save > $HOME/iptables.rules

        tor_uid="debian-tor"

SP='255.255.255.255/32 240.0.0.0/4 233.252.0.0/24 224.0.0.0/4 203.0.113.0/24 198.51.100.0/24 198.18.0.0/15 192.168.0.0/16 192.88.99.0/24 192.0.2.0/24 192.0.0.0/24 172.16.0.0/12 169.254.0.0/16 127.0.0.0/8 100.64.0.0/10 10.0.0.0/8 0.0.0.0/8'

  iptables -t nat -F
  iptables -t nat -X
  iptables -t nat -Z

  iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 9053
  iptables -t nat -A OUTPUT -p tcp -d 10.192.0.0/10 --syn -j REDIRECT --to-ports 9040

  iptables -t nat -A OUTPUT -m owner --uid-owner $tor_uid -j RETURN
  iptables -t nat -A OUTPUT -o lo -j RETURN


  iptables -A OUTPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT
  iptables -A OUTPUT -m owner --uid-owner $tor_uid -j ACCEPT

  iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT
  iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

  for sp in $SP; do
    iptables -t nat -A OUTPUT -d $sp -j RETURN
  done

  iptables -t nat -A OUTPUT -p udp -j REDIRECT --to-ports 9040
  iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports 9040
  iptables -t nat -A OUTPUT -p tcp  -j REDIRECT --to-ports 9040

  iptables -t nat -A PREROUTING -p tcp  -j REDIRECT --to-ports 9040
  iptables -t nat -A PREROUTING -p udp  -j REDIRECT --to-ports 9040


echo -e "start Tor"

exit 0

elif [[ "$1" == "stop" ]]; then
        iptables -t nat -F
        iptables -t nat -X

        #enable ipv6
        sysctl -w net.ipv6.conf.all.disable_ipv6=0
        sysctl -w net.ipv6.conf.default.disable_ipv6=0
        sysctl -w net.ipv6.conf.lo.disable_ipv6=0

        iptables-restore <  $HOME/iptables.rules

        killall tor

else
        exit 1
fi

exit 0