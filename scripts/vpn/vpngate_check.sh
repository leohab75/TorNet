#!/bin/bash

icon="/usr/local/bin/TorNet/source/icons/TorNet.png"
TorNet="<span foreground='red' font='14'>T</span>orNet \n"

if [[ $1 == "choice" ]]; then

    choice=$(zenity --list --radiolist --window-icon="$icon" --title="Add to favorites server" --text="$TorNet Только для текущего соединения:" --column="🔆" --column="choice" --column="Действие" FALSE "white" "добавить в белый список" \
        FALSE "black" "добавить в черный список" --height=300 --width=400)

    if [[ "$?" == "0" ]]; then

        host_name=$(cat /usr/local/bin/TorNet/tmp/_Hoster_) 2 &>/dev/null

        if [[ -z $(pidof openvpn) ]]; then

            zenity --error --title="add to favorite" --text="$TorNet Нет активного OpenVpn клиента" --width=300
        else
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

            fi
        fi
    fi

elif
    [[ $1 == "sort" ]]
then

    if grep -q "$2" /usr/local/bin/TorNet/tmp/white_list 2 &>/dev/null; then
        echo -e "🟢"
    elif grep -q "$2" /usr/local/bin/TorNet/tmp/black_list 2 &>/dev/null; then
        echo -e "🔴"
    else
        echo -e "⚫"
    fi

fi
