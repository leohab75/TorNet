#!/bin/bash

icon="/usr/local/bin/TorNet/source/icons/TorNet.png"
TorNet="<span foreground='red' font='12'>T</span>orNet"

cd /usr/local/bin/TorNet/scripts/proxy/ || exit 1

zenity --notification --text="TorNet \n SOCKS5 PROXY"

choice=$(zenity --list --radiolist --window-icon="$icon" --title="Proxy socks5://" --text="$TorNet \n SOCKS5 PROXY" --column="🔆" --column="PROXY:PORT" \
    --column="code" --column="flag" "true" "UPDATE" "proxy" "list" $(for i in $(cat socks5);
    do
        country_code=$(curl  -m 5 --socks5 "$i" ifconfig.io/country_code)
        zenity --notification --text="TorNet \n Check: $i"
        echo -en "false $i $(bash /usr/local/bin/TorNet/scripts/country_flags.sh $country_code) \n"
    done) --width=350 --height=450)

if [[ "$?" == "0" ]]; then

    if [[ "$choice" == "UPDATE" ]]; then

        if [[ -f "socks5" ]]; then
            rm -f socks5
        fi

        python3 /usr/local/bin/TorNet/scripts/proxy/proxyScraper.py -p socks5 -o socks5


        all_proxy=$(wc -l socks5)

        buff=$(zenity --list --radiolist --window-icon="$icon" --title="Proxy socks5://" --text="$TorNet \n Всего: $all_proxy \n " \
            --column="🔆" --column="PROXY:PORT" --column="code" --column="flag" $(for i in $(cat socks5); do
                country_code=$(curl -m 5 --socks5 "$i"  ifconfig.io/country_code)
                zenity --notification --text="TorNet \n Check: $i"
                echo -en "false $i $(bash /usr/local/bin/TorNet/scripts/country_flags.sh $country_code) \n"
            done) --width=350 --height=450)

        echo "$buff" | xclip -sel clip

    else
        echo "$choice" | xclip -sel clip
    fi

fi

exit 0
