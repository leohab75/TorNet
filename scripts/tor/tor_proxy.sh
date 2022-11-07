#!/bin/bash
icon="/usr/local/bin/TorNet/source/icons/TorNet.png"
TorNet="<span foreground='red' font='14'>T</span>orNet \n"

#включаем, если выключен snowf..
if [[ -z $(pidof snowflake-client) ]]; then
    cd /usr/local/bin/TorNet/snowflake/client/ || (
        zenity --info --text="$TorNet ошибка пути \n /usr/local/bin/TorNet/snowflake/client/"
        exit 1
    )
    tor -f torrc | tee snow.log &

    xrdb /usr/local/bin/TorNet/source/.Xdefaults
    xterm -e "tail -f snow.log | stdbuf -oL cut -d ' ' -f5-  " &

    while true; do

        sleep 5
        if grep -q "Bootstrapped 100%" snow.log; then
            zenity --info --window-icon="$icon" --text="$TorNet\n Snowflake client Enabled \n\t для проверки укажите\n curl --socks5 127.0.0.1:2323 ifconfig.me"
            break
        fi
    done
fi

TorSocs=$(netstat -anlutp | grep -i "2323" | awk 'NR == 1 {print $4}')
if [[ $TorSocs = "" ]]; then
    zenity --warning --window-icon="$icon" --title="Socks5" --text="$TorNet Неудалось подключится ... ¯\_(ツ)_/¯\n    ...попробуйте позже " --height=200 --width=300
else

    zenity --notification --text="TorNet \n snowflake-client5 enabled"
fi
