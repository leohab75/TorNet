#!/bin/bash

icon="/usr/local/bin/TorNet/source/icons/TorNet.png"
host_name=$(cat /usr/local/bin/TorNet/tmp/_Hoster_)

if [[ $1 == "choice" ]]; then
    choice=$(zenity --list --radiolist --window-icon="$icon" --title="Add to favorites server" --text="Только для текущего соединения:" --column="🔆" --column="choice" --column="Действие" FALSE "white" "добавить в белый список" \
        FALSE "black" "добавить в черный список" FALSE "clean" "отчистить списки" --hide-column="2" --height=200 --width=400)

    if [[ "$?" == "0" ]]; then

        path_tmp=$(cat /usr/local/bin/TorNet/tmp/_Hoster_)
        line="$(cat /usr/local/bin/TorNet/tmp/_Hoster_ | grep -i "$host_name" | awk '{print NR}')"

        if [[ ! -d /usr/local/bin/TorNet/tmp/servers/ ]]; then
            mkdir /usr/local/bin/TorNet/tmp/servers
        fi

        if [[ "$choice" == "white" ]]; then

            cat /usr/local/bin/TorNet/source/server.ovpn >/usr/local/bin/TorNet/tmp/servers/"$path_tmp"
            curl ifconfig.io/country_code >>/usr/local/bin/TorNet/tmp/servers/"$path_tmp"

            if [[ -n $line ]]; then
                tail -n $line /usr/local/bin/TorNet/tmp/black_list | wc -c | xargs -I {} truncate "/usr/local/bin/TorNet/tmp/black_list" -s -{}
            fi

            echo -e "$host_name" >>/usr/local/bin/TorNet/tmp/white_list
            sed -i '$!N; /^\(.*\)\n\1$/!P; D' /usr/local/bin/TorNet/tmp/white_list

        elif [[ "$choice" == "black" ]]; then

            rm -f /usr/local/bin/TorNet/tmp/servers/"$path_tmp" 2 &>/dev/null

            if [[ -n $line ]]; then
                tail -n $line /usr/local/bin/TorNet/tmp/white_list | wc -c | xargs -I {} truncate "/usr/local/bin/TorNet/tmp/white_list" -s -{}
            fi

            echo -e "$host_name" >>/usr/local/bin/TorNet/tmp/black_list
            sed -i '$!N; /^\(.*\)\n\1$/!P; D' /usr/local/bin/TorNet/tmp/black_list

        else
            rm -f '/usr/local/bin/TorNet/tmp/black_list' '/usr/local/bin/TorNet/tmp/white_list' '/usr/local/bin/TorNet/tmp/servers'

        fi
    fi

elif [[ $1 == "sort" ]]; then

    if grep -q "$2" /usr/local/bin/TorNet/tmp/white_list; then
        echo -e "🟢"
    elif grep -q "$2" /usr/local/bin/TorNet/tmp/black_list; then
        echo -e "🔴"
    else
        echo -e "⚫"
    fi

elif [[ $1 == "saved" ]]; then

    list=$(ls "/usr/local/bin/TorNet/tmp/servers")
    select_server=$(zenity --list --radiolist --window-icon="$icon" --title="TorNet" --text="Сохранённые сервера:" \
     --column="🔆" --column="hostname" --column="IP" --column="code" --column="flag" \
      $(for i in $list; do
        echo -e "false"
        echo -e "$i"
        echo -e "$(cat /usr/local/bin/TorNet/tmp/servers/$i | grep 'remote' | awk ' NR ==2 {print $2}')"
        code=$(cat /usr/local/bin/TorNet/tmp/servers/$i | awk 'END{print}')
        bash /usr/local/bin/TorNet/scripts/country_flags.sh "$code"
    done) --height=500 --width=400)

    if [[ $? == "0" ]]; then
        cat /usr/local/bin/TorNet/tmp/servers/$select_server | sed '$d' | tee /usr/local/bin/TorNet/source/server.ovpn 1&>/dev/null

        pkexec bash /usr/local/bin/TorNet/scripts/vpngate_select.sh &

        (for ((i = 1; i <= 30; i++)); do
            echo -e "# connect Vpn Gate ... $i сек (30)"
            sleep 1
        done) | zenity --window-icon="$icon" --progress --pulsate --title="Connect" --no-cancel --width=300 --auto-close --auto-kill

        if grep -q "Initialization Sequence Completed" /usr/local/bin/TorNet/tmp/vpn.log; then
            zenity --info --window-icon="$icon" --text="Initialization Sequence Completed"
        elif grep -q "Options error: unknown --redirect-gateway flag: def" /usr/local/bin/TorNet/tmp/vpn.log; then
            zenity --error --window-icon="$icon" --text="Options error: unknown --redirect-gateway flag: def"

        elif grep -q "AUTH: Received control message: AUTH_FAILED" /usr/local/bin/TorNet/tmp/vpn.log; then
            zenity --error --window-icon="$icon" --text="AUTH: Received control message: AUTH_FAILED"

        else
            zenity --error --window-icon="$icon" --text="ERROR \n Connect is failed -def"

        fi

        TorNet 1 &>/dev/null
    fi

fi
