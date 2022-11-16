#!/bin/bash

export BLUE='\033[1;94m'
export GREEN='\033[1;92m'
export RED='\033[1;91m'
export RESETCOLOR='\033[1;00m'

echo -e "\n $GREEN*$BLUE Определятся версия ОС \n"

if [[ -n $(grep -i "ubuntu" /etc/os-release) ]]; then

    echo -e "\n $RED -------------"
    echo -e "Relese OS: "
    echo -e "\n $GREEN Ubuntu "
    echo -e "\n $BLUE   for Name: $RED<<$GREEN $(lsb_release -cs) $RED>>   "
    echo -e "\n $RED -------------\n$RESETCOLOR"

    echo -e "\n$GREEN  Установка Тор и зависимостей \n$RESETCOLOR"

    apt install zenity wget openresolv net-tools openvpn curl xclip network-manager-openvpn network-manager-openvpn-gnome network-manager-vpnc -y
    apt install pip -y || apt install python3-pip -y
    apt install libappindicator3-1 libappindicator3-dev -y
    apt install gir1.2-appindicator3-0.1 -y
    apt install tor torsocks -y

    #ставим cloudflared
    curl https://pkg.cloudflare.com/cloudflare-main.gpg -o /usr/share/keyrings/cloudflare-main.gpg
    wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
    apt install ./cloudflared-linux-amd64.deb

    dpkg --configure -a

elif [[ -n $(grep -i "fedora" /etc/os-release) ]]; then

    echo -e "\n $RED -------------"
    echo -e "Relese OS: "
    echo -e "\n $GREEN fedora | RHEL "
    echo -e "\n $BLUE  cloudflred for: $RED <<$GREEN el7 $RED>>   "
    echo -e "\n $RED -------------\n$RESETCOLOR"

    echo -e "\n$GREEN  Установка Тор и зависимостей \n$RESETCOLOR"
    dnf makecache --refresh
    dnf install tor zenity wget curl openresolv net-tools openvpn torsocks pip xclip NetworkManager-openvpn NetworkManager-openvpn-gnome -y

    dnf install libappindicator-gtk3 -y || dnf install libappindicator-gtk3-devel -y

    rpm -e gpg-pubkey-8e5f9a5d-*
    rpm --import https://pkg.cloudflare.com/pubkey.gpg
    wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-x86_64.rpm
    rpm -ivh cloudflared-linux-x86_64.rpm

else

    echo -e "\n----------------"
    echo -e "\n $RED NOT release "
    echo -e "----------------\n$RESETCOLOR"

    exit 1
fi

echo -e "\n$GREEN*$BLUE подготовка перед копированием \n$RESETCOLOR"
rm -rf /usr/local/bin/TorNet* /usr/share/applications/TorNet.desktop /usr/share/applications/Uninstall_TorNet.desktop
rm -f /usr/bin/TorNet /usr/bin/Uninstall_TorNet

if ! [[ -e /usr/local ]]; then
    mkdir /usr/local
    if ! [[ -e /usr/local/bin ]]; then
        mkdir /usr/local/bin
    fi
fi

echo -e "\n$GREEN*$BLUE копирование в рабочие каталоги \n$RESETCOLOR"
mv /tmp/TorNet/source/TorNet.desktop /usr/share/applications/
mv /tmp/TorNet/source/Uninstall_TorNet.desktop /usr/share/applications/

mv /tmp/TorNet/bin/TorNet /usr/bin
mv /tmp/TorNet/bin/Uninstall_TorNet /usr/bin

cp -r /tmp/TorNet /usr/local/bin

echo -e "\n$GREEN*$BLUE настройка cloudfare over https\n $RESETCOLOR"

systemctl stop systemd-resolved
systemctl disable systemd-resolved

cp /tmp/TorNet/source/cloudflared-proxy-dns.service /etc/systemd/system/
systemctl enable --now cloudflared-proxy-dns

sed -i '/name_servers/d' /etc/resolvconf.conf
echo -e "name_servers=127.0.0.1" >>/etc/resolvconf.conf
mv /etc/resolv.conf /etc/resolv.conf.back
rm -f /etc/resolv.conf

echo nameserver 127.0.0.1 | tee /etc/resolv.conf
# systemctl restart NetworkManager

echo -e "\n$GREEN*$BLUE правим конфиги Network\n $RESETCOLOR"

tee /etc/NetworkManager/conf.d/dns.conf <<EOF
[main]
dns=none
EOF

tee /etc/NetworkManager/conf.d/rc-manager.conf <<EOF
[main]
rc-manager=resolvconf
EOF

#for bash completion
mv /tmp/TorNet/source/TorNet /etc/bash_completion.d/TorNet
source   /etc/bash_completion.d/TorNet

systemctl disable tor
# echo -e "\n$GREEN включение сервиса Тор\n$RESETCOLOR"
# systemctl enable tor
# systemctl start tor

chmod +x /usr/bin/TorNet
chmod +x /usr/bin/Uninstall_TorNet

systemctl restart cloudflared-proxy-dns.service

_User_=$(cat /tmp/TorNet/_User_)

chmod 766 /usr/bin/TorNet
chmod 766 /usr/bin/Uninstall_TorNet
chown "$_User_" -R /usr/local/bin/TorNet/

sleep 3
resolvconf -u

update-desktop-database && update-icon-caches /usr/local/bin/TorNet/source/icons/TorNet.png
exit 0
