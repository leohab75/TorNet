#!/usr/bin/env bash

icon="/usr/local/bin/TorNet/source/icons/TorNet.png"
hoster=$(cat /usr/local/bin/TorNet/tmp/_Hoster_)

if [[ $1 == "choice" ]]; then
    choice=$(zenity --list --radiolist --window-icon="$icon" --title="Add to favorites server" --text="Только для текущего соединения:" --column="🔆" --column="choice" --column="Действие" FALSE "white" "добавить в белый список" \
      FALSE "black" "добавить в черный список" FALSE "clean" "отчистить списки" --hide-column="2" --height=200 --width=400)

    if [[ "$?" == "0" ]]; then

        if [[ "$choice" == "white" ]]; then

            echo -e "$hoster" >>/usr/local/bin/TorNet/tmp/white_list
            sed -i '$!N; /^\(.*\)\n\1$/!P; D' /usr/local/bin/TorNet/tmp/white_list

        elif [[ "$choice" == "black" ]]; then

            echo -e "$hoster" >>/usr/local/bin/TorNet/tmp/black_list
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
