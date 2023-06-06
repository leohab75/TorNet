#!/bin/bash

icon="/usr/local/bin/TorNet/source/icons/TorNet.png"
TorNet="<span foreground='red' font='12'>T</span>orNet"

cd /usr/local/bin/TorNet/scripts/proxy/ || exit 1

zenity --notification --text="TorNet \n HTTP PROXY"

choice=$(zenity --list --radiolist --window-icon="$icon" --title="Proxy http://" --text="$TorNet \n HTTP PROXY" --column="🔆" --column="PROXY:PORT" \
    --column="code" --column="flag" "true" "UPDATE" "proxy" "list" $(for i in $(cat http); do
        country_code=$(curl -m 5 -x "$i" ifconfig.io/country_code)
        echo -en "false $i $(bash /usr/local/bin/TorNet/scripts/country_flags.sh $country_code) \n"
    done) --width=350 --height=450)

if [[ "$?" == "0" ]]; then

    if [[ "$choice" == "UPDATE" ]]; then

        if [[ -f "http" ]]; then
            rm -f http
        fi

        if [[ -f "https" ]]; then
            rm -f https
        fi

        if [[ -d $HOME/Desktop ]]; then
            Desktop_path="Desktop"
        else
            Desktop_path="Рабочий стол"
        fi

        rm "$HOME/$Desktop_path/TorNet proxy HTTP.txt" 2 &>/dev/null

        python3 /usr/local/bin/TorNet/scripts/proxy/proxyScraper.py -p http -o http

        (python3 /usr/local/bin/TorNet/scripts/proxy/proxyChecker.py -p http -t 10 -s google.com -l http) | zenity --progress --title="Check proxy" \
            --pulsate --text="$TorNet" --auto-kill --auto-close --no-cancel --width=450 --height=100

        all_proxy=$(wc -l http)

        buff=$(zenity --list --radiolist --window-icon="$icon" --title="Proxy http://" --text="$TorNet \n Всего: $all_proxy \n " \
            --column="🔆" --column="PROXY:PORT" --column="code" --column="flag" $(for i in $(cat http); do
                country_code=$(curl -x "$i" -m 5 ifconfig.io/country_code)
                echo -en "false $i $(bash /usr/local/bin/TorNet/scripts/country_flags.sh $country_code) \n"
                echo -e "$i  $country_code" >> "$HOME/$Desktop_path/TorNet proxy HTTP.txt"
            done) --width=350 --height=450)

        echo "$buff" | xclip -sel clip

    else
        echo "$choice" | xclip -sel clip
    fi

fi

exit 0
