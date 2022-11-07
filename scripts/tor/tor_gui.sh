#!/bin/bash
icon="/usr/local/bin/TorNet/source/icons/TorNet.png"
TorNet="<span foreground='red' font='12'>T</span>orNet"

start="/usr/local/bin/TorNet/source/icons/Icon/start.png"
stop="/usr/local/bin/TorNet/source/icons/Icon/stop.png"
proxy5="/usr/local/bin/TorNet/source/icons/Icon/proxy.png"


menu=$(
    GDK_DPI_SCALE=1.1 zenity --window-icon="$icon" --text="$TorNet" --list --imagelist --column="Icon" --column="Опции" --column="Описание" --title="TorNet" \
        "$start" "START" "start | proxy tor" \
        "$stop" "STOP" "stop | proxy tor" \
        "$proxy5" "PROXY" "client snowflake" --height=260 --width=430
)

case "$menu" in

"$start")
    TorNet 'start_tor'
    ;;
"$stop")
    TorNet 'stop_tor'
    ;;
"$proxy5")
    bash /usr/local/bin/TorNet/scripts/tor/tor_proxy.sh
    TorNet_tray
    ;;

esac
