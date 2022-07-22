#!/bin/bash

if [[ ! -f iptables.rules ]]; then
        iptables-save >iptables.rules
fi

if [[ "$1" = "start" ]]; then

        bash /usr/local/bin/TorNet/scripts/vpngate_stop.sh

        iptables-save >iptables.rules

        #disabled ipv6
        sysctl -w net.ipv6.conf.all.disable_ipv6=1
        sysctl -w net.ipv6.conf.default.disable_ipv6=1
        sysctl -w net.ipv6.conf.lo.disable_ipv6=1

        echo '(Re)starting redsocks...'
        pkill -U $USER redsocks2 2>/dev/null
        sleep 1
        /usr/local/bin/TorNet/bin/redsocks2 -c /etc/redsocks.conf

        iptables -t nat -N REDSOCKS
        iptables -t nat -A REDSOCKS -d 0.0.0.0/8 -j RETURN
        iptables -t nat -A REDSOCKS -d 10.0.0.0/8 -j RETURN
        iptables -t nat -A REDSOCKS -d 127.0.0.0/8 -j RETURN
        iptables -t nat -A REDSOCKS -d 169.254.0.0/16 -j RETURN
        iptables -t nat -A REDSOCKS -d 172.16.0.0/12 -j RETURN
        iptables -t nat -A REDSOCKS -d 192.168.0.0/16 -j RETURN
        iptables -t nat -A REDSOCKS -d 224.0.0.0/4 -j RETURN
        iptables -t nat -A REDSOCKS -d 240.0.0.0/4 -j RETURN

        #cloudflared
        iptables -t nat -A REDSOCKS -p tcp --dport 53 -j REDIRECT --to-ports 53
        iptables -t nat -A REDSOCKS -p udp --dport 53 -j REDIRECT --to-ports 53

        #all tcp/udp to REDSOCKS
        iptables -t nat -A REDSOCKS -p tcp -j REDIRECT --to-ports 8123
        iptables -t nat -A REDSOCKS -p udp -j REDIRECT --to-ports 8123

        #for web standart
        #iptables -t nat -A REDSOCKS -p tcp --dport 80 -j REDIRECT --to-ports 8123
        #iptables -t nat -A REDSOCKS -p tcp --dport 8080 -j REDIRECT --to-ports 8123
        #iptables -t nat -A REDSOCKS -p tcp --dport 443 -j REDIRECT --to-ports 8123

        iptables -t nat -A OUTPUT -p tcp -j REDSOCKS
        iptables -t nat -A OUTPUT -p udp -j REDSOCKS

        iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDSOCKS
        iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDSOCKS
        iptables -t nat -A PREROUTING -p tcp --dport 8080 -j REDSOCKS

        echo IPtables reconfigured.
        exit 0
elif [[ "$1" = "stop" ]]; then
        iptables -t nat -F
        iptables -t nat -X

        #enable ipv6
        sysctl -w net.ipv6.conf.all.disable_ipv6=0
        sysctl -w net.ipv6.conf.default.disable_ipv6=0
        sysctl -w net.ipv6.conf.lo.disable_ipv6=0

        iptables-restore <iptables.rules
        killall redsocks2
        echo All be back
else
        exit 1
fi

#finish
exit 0