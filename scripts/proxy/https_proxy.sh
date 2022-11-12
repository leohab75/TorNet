#!/bin/bash

icon="/usr/local/bin/TorNet/source/icons/TorNet.png"
TorNet="<span foreground='red' font='12'>T</span>orNet"

cd /usr/local/bin/TorNet/scripts/proxy/ || exit 1

zenity --notification --text="TorNet \n HTTPs PROXY"

choice=$(zenity --list --radiolist --window-icon="$icon" --title="Proxy https://" --text="$TorNet \n HTTPS PROXY" --column="🔆" --column="PROXY:PORT" \
    --column="code" --column="flag" "true" "UPDATE" "proxy" "list" $(for i in $(cat output.txt);
    do
        country_code=$(curl  -m 30 -x "$i" -L ifconfig.io/country_code)
        echo -en "false $i $(bash /usr/local/bin/TorNet/scripts/country_flags.sh $country_code) \n"
    done) --width=350 --height=450)

if [[ "$?" == "0" ]]; then

    if [[ "$choice" == "UPDATE" ]]; then

        if [[ -f "output.txt" ]]; then
            rm -f output.txt
        fi

        python3 /usr/local/bin/TorNet/scripts/proxy/proxyScraper.py -p https

        (python3 /usr/local/bin/TorNet/scripts/proxy/proxyChecker.py -p https -t 20 -s google.com -l output.txt) | zenity --progress --title="Check proxy" \
            --pulsate --text="$TorNet" --auto-kill --auto-close --no-cancel --width=450 --height=100

        all_proxy=$(wc -l output.txt)

        buff=$(zenity --list --radiolist --window-icon="$icon" --title="Proxy https://" --text="$TorNet \n Всего: $all_proxy \n " \
            --column="🔆" --column="PROXY:PORT" --column="code" --column="flag" $(for i in $(cat output.txt); do
                country_code=$(curl -s -x "$i" -L ifconfig.io/country_code)
                echo -en "false $i $(bash /usr/local/bin/TorNet/scripts/country_flags.sh $country_code) \n"
            done) --width=350 --height=450)

        echo "$buff" | xclip -sel clip

    else
        echo "$choice" | xclip -sel clip
    fi

fi

exit 0
