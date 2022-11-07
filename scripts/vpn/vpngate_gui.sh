#!/bin/env bash

declare start_v favorite_v addTofavorite_v stop_v

icon="/usr/local/bin/TorNet/source/icons/TorNet.png"
TorNet="<span foreground='red' font='12'>T</span>orNet"

start_v="/usr/local/bin/TorNet/source/icons/Icon/start.png"
favorite_v="/usr/local/bin/TorNet/source/icons/Icon/favorite.png"
addTofavorite_v="/usr/local/bin/TorNet/source/icons/Icon/addTo.png"
stop_v="/usr/local/bin/TorNet/source/icons/Icon/stop.png"

menu=$(
    zenity --window-icon="$icon" --text="$TorNet" --list --imagelist --column="Icon" --column="Опции" --title="TorNet" \
        "$start_v" "Start VPNGate" \
        "$favorite_v" "favorites list" \
        "$addTofavorite_v" "add to favorite" \
        "$stop_v" "stop all VPN" --height=260 --width=430
)

if [[ "$?" == "0" ]]; then

case "$menu" in

"$start_v")
    bash /usr/local/bin/TorNet/scripts/vpn/vpngate_select_gui.sh
    ;;
"$stop_v")
    pkexec bash /usr/local/bin/TorNet/scripts/vpn/vpngate_stop.sh
    TorNet
    ;;
"$favorite_v")
    bash "/usr/local/bin/TorNet/scripts/vpn/vpngate_favorite.sh"
    TorNet
    ;;
"$addTofavorite_v")
    echo "TEST"
    bash /usr/local/bin/TorNet/scripts/vpn/vpngate_check.sh 'choice'
    TorNet
    ;;
    
esac
fi