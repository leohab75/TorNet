#!/bin/bash

export GREEN='\033[1;92m'
export RESETCOLOR='\033[1;00m'

#dns resolver setting
if [[ "$1" == "cloudflared" ]]; then

    echo -e "$GREEN Уже всё готово $RESETCOLOR"

elif [[ "$1" == "systemd" ]]; then

    rm -f /etc/NetworkManager/conf.d/dns.conf
    rm -f /etc/NetworkManager/conf.d/rc-manager.conf

    systemctl stop cloudflared-proxy-dns
    systemctl disable cloudflared-proxy-dns

    rm -rf /etc/default/cloudflared
    rm -rf /etc/systemd/system/cloudflared-proxy-dns.service

    sed -i '/name_servers/d' /etc/resolvconf.conf
    echo -e "name_servers=127.0.0.53" >>/etc/resolvconf.conf

    echo "nameserver  127.0.0.53" | tee /etc/resolv.conf

    systemctl enable systemd-resolved
    systemctl start systemd-resolved

    resolvconf -u

elif [[ "$1" == "users" ]]; then

    rm -f /etc/NetworkManager/conf.d/dns.conf
    rm -f /etc/NetworkManager/conf.d/rc-manager.conf

    systemctl stop cloudflared-proxy-dns
    systemctl disable cloudflared-proxy-dns

    rm -rf /etc/default/cloudflared
    rm -rf /etc/systemd/system/cloudflared-proxy-dns.service

    sed -i '/name_servers/d' /etc/resolvconf.conf

    for read in line; do
        echo "name_servers=$line" >>/etc/resolvconf.conf
    done | /usr/local/bin/TorNet/users_dns

    rm -f /etc/resolv.conf

    for read in dns_name; do
        echo "nameserver  $dns_name" >>/etc/resolv.conf
    done | cat /usr/local/bin/TorNet/users_dns

    resolvconf -u

else
    exit 1

fi

#пакеты не удаляю, только файлы конфигураций

rm -rf /usr/local/bin/TorNet/
rm -f /usr/share/applications/TorNet.desktop
rm -f /usr/share/applications/Uninstall_TorNet.desktop

rm /usr/bin/TorNet
rm /usr/bin/Uninstall_TorNet

rm -f /etc/sudoers.d/TorNet_no_passwd
rm -f  /etc/bash_completion.d/TorNet


systemctl daemon-reload

#finish
exit 0
