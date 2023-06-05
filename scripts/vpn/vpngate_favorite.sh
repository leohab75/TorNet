#!/bin/bash

icon="/usr/local/bin/TorNet/source/icons/TorNet.png"
TorNet="<span foreground='red' font='14'>T</span>orNet \n"

if [[ -d /usr/local/bin/TorNet/tmp/servers/ ]]; then

    list=$(ls "/usr/local/bin/TorNet/tmp/servers")
    select_server=$(zenity --list --radiolist --window-icon="$icon" --title="TorNet" --text="$TorNet Сохранённые сервера:" \
        --column="🔆" --column="hostname" --column="Created" --column="Ip" --column="code" --column="flag" \
        $(for i in $list; do
            echo -e "false"
            echo -e "$i"
            echo -e "$(stat -c %y  /usr/local/bin/TorNet/tmp/servers/$i | awk '{print $1}')"
            echo -e "$(cat /usr/local/bin/TorNet/tmp/servers/$i | grep remote | awk 'NR == 2 {print $2}')"
            code=$(cat /usr/local/bin/TorNet/tmp/servers/$i | awk 'END{print}')
            bash /usr/local/bin/TorNet/scripts/country_flags.sh "$code"
        done) false "delete" "❌" "👉🏻 Удалить" "список" "серверов" --height=500 --width=500)

    if [[ $? == "0" ]]; then
        if [[ ! $select_server == "" ]]; then

            if [[ $select_server == "delete" ]]; then

                rm -rf '/usr/local/bin/TorNet/tmp/black_list' '/usr/local/bin/TorNet/tmp/white_list' '/usr/local/bin/TorNet/tmp/servers' '/usr/local/bin/TorNet/tmp/server_conf'

            else

                cat /usr/local/bin/TorNet/tmp/servers/$select_server | sed '$d' | tee /usr/local/bin/TorNet/source/TorNet.ovpn  1 &>/dev/null

                pkexec bash /usr/local/bin/TorNet/scripts/vpngate_select.sh &



                TorNet 1&>/dev/null
            fi
        fi
    fi

else
    zenity --warning --window-icon="$icon" --text="$TorNet Список серверов пуст" --width="200"
fi
