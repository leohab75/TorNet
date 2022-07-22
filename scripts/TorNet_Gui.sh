#!/usr/bin/env bash

start_tor="/usr/local/bin/TorNet/source/icons/Icon/tor__1.png"
stop_tor="/usr/local/bin/TorNet/source/icons/Icon/tor_2.png"
vpn_select="/usr/local/bin/TorNet/source/icons/Icon/link.png"
vpn_stop="/usr/local/bin/TorNet/source/icons/Icon/link__1.png"
status="/usr/local/bin/TorNet/source/icons/Icon/check.png"
torsocks="/usr/local/bin/TorNet/source/icons/Icon/loading.png"
speedtest="/usr/local/bin/TorNet/source/icons/Icon/speedtest.png"
icon="/usr/local/bin/TorNet/source/icons/TorNet.png"

#меню утилиты zenity
while true; do

    menu=$(zenity --window-icon="$icon" --list --imagelist --column="Icon" --column="Select" --column="Edit" --text="    " \
        "$start_tor" " 😎 START TOR" "| Пропуcтить весь трафик через TOR" \
        "$stop_tor" " 🚫 STOP TOR" "| Выключить проксирование TOR" \
        "$vpn_select" " 🙊 SELECT VPN" "| Выбрать VPN сервер (~99)" \
        "$vpn_stop" "☠ STOP VPN" "| Выключить all VPN" \
        "$torsocks" " 👻 PROXY SOCKS5" "| Socks5 127.0.0.1:2323" \
        "$speedtest" " 💬 SPEEDTEST" "| Тест скорости Ookla" \
        "$status" " 🌎 STATUS TORNET " "| Показать текущий IP" --height=455 --width=455)

    case "$menu" in

    "$start_tor")
        TorNet 'start tor'
        ;;
    "$stop_tor")
        TorNet 'stop tor'
        ;;
    "$status")
        TorNet 'status'
        ;;
    "$vpn_select")
        TorNet 'select vpn'
        ;;
    "$torsocks")
        TorNet 'proxy'
        ;;
    "$speedtest")
        TorNet 'speedtest'
        ;;
    "$vpn_stop")
        TorNet 'vpn stop'
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

#finish
exit 0