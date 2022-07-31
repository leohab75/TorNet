#!/usr/bin/env bash

icon="/usr/local/bin/TorNet/source/icons/TorNet.png"
host_name=$(cat /usr/local/bin/TorNet/tmp/_Hoster_)

if [[ $1 == "choice" ]]; then
    choice=$(zenity --list --radiolist --window-icon="$icon" --title="Add to favorites server" --text="Только для текущего соединения:" --column="🔆" --column="choice" --column="Действие" FALSE "white" "добавить в белый список" \
        FALSE "black" "добавить в черный список" FALSE "clean" "отчистить списки" --hide-column="2" --height=200 --width=400)

    if [[ "$?" == "0" ]]; then

        line="$(cat /usr/local/bin/TorNet/tmp/_Hoster_ | grep -i "$host_name" | awk '{print NR}')"

        if [[ "$choice" == "white" ]]; then

            if [[ -n $line ]]; then
                tail -n $line /usr/local/bin/TorNet/tmp/black_list | wc -c | xargs -I {} truncate "/usr/local/bin/TorNet/tmp/black_list" -s -{}
            fi

            echo -e "$host_name" >>/usr/local/bin/TorNet/tmp/white_list
            sed -i '$!N; /^\(.*\)\n\1$/!P; D' /usr/local/bin/TorNet/tmp/white_list

        elif [[ "$choice" == "black" ]]; then

            if [[ -n $line ]]; then
                tail -n $line /usr/local/bin/TorNet/tmp/white_list | wc -c | xargs -I {} truncate "/usr/local/bin/TorNet/tmp/white_list" -s -{}
            fi

            echo -e "$host_name" >>/usr/local/bin/TorNet/tmp/black_list
            sed -i '$!N; /^\(.*\)\n\1$/!P; D' /usr/local/bin/TorNet/tmp/black_list

        else
            rm -f '/usr/local/bin/TorNet/tmp/black_list' '/usr/local/bin/TorNet/tmp/white_list'

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

fi
