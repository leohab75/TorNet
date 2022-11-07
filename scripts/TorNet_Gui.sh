#!/usr/bin/env bash

tor="/usr/local/bin/TorNet/source/icons/TorNetT.png"
vpn="/usr/local/bin/TorNet/source/icons/TorNetV.png"
proxy="/usr/local/bin/TorNet/source/icons/TorNet5.png"
icon="/usr/local/bin/TorNet/source/icons/TorNet.png"

TorNet="<span foreground='red' font='12'>T</span>orNet"


#меню утилиты zenity
while true; do

    menu=$(
        GDK_DPI_SCALE=1.1 zenity --window-icon="$icon" --text="$TorNet" --list --imagelist --column="Icon" --column="Опции" --column="Описание" --title="TorNet" \
            "$tor" "TOR" "start | proxy | stop" \
            "$vpn" "VPN" "start | favorite | add to.. | stop" \
            "$proxy" "PROXY" "list HTTPS proxy"  --height=280 --width=480 )

    case "$menu" in

    "$tor")
        TorNet 'gui_tor'
        ;;
    "$vpn")
        TorNet 'gui_vpn'
        ;;
    "$proxy")
        TorNet 'gui_proxy'
        ;;
    *)
        break
        ;;
    esac

done

#сообщение статуса notifi
IP=$(wget -qO- eth0.me)
Socks_IP=$(curl --socks5 127.0.0.1:2323 http://eth0.me)

zenity --notification --text="Ваш текущий IP адрес: $IP \n\ IP через socks5: $Socks_IP "

exit 0
