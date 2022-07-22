#!/usr/bin/env bash

icon="/usr/local/bin/TorNet/source/icons/TorNet.png"
cd "/usr/local/bin/TorNet/" || exit 1

if [[ -f "./tmp/server_list.csv" ]]; then
    rm -f ./tmp/server_list.csv
fi

#забираем конфиг. файл
response=$(curl --write-out '%{http_code}' --silent --output ./tmp/server_list.csv http://www.vpngate.net/api/iphone/)

if [[ ! "$response" == "200" ]]; then
    TorNet proxy &
    sleep 30
    curl --socks5 127.0.0.1:2323 http://www.vpngate.net/api/iphone/ --silent --output ./tmp/server_list.csv
fi

if [[ -f "./tmp/server_list.csv" ]]; then

    enabled_servers=$(cat ./tmp/server_list.csv | wc -l)
    sed -i 's/ /_/g; /*/d; 2d' ./tmp/server_list.csv

    cat ./tmp/server_list.csv | awk '{print $1}' | cut -f 6 -d "," | sort -u | tee ./tmp/tmp_Country_name 1 &>/dev/null
    cat ./tmp/server_list.csv | awk '{print $1}' | cut -f 7 -d "," | sort -u | tee ./tmp/tmp_Country_code 1 &>/dev/null

    rm ./tmp/tmp_Country_node
    for i in $(cat ./tmp/tmp_Country_name); do grep "$i" ./tmp/server_list.csv | wc -l >>./tmp/tmp_Country_node; done

    select_server=$(zenity --list --radiolist --window-icon="$icon" --title="vpngate best servers" --text="Активные сервера: \
Всего $enabled_servers" --column="Use" --column="Country" --column="Code" --column="" --column="FLAGS" --column="Кол-во" --hide-column="4" \
        $(for j in $(cat ./tmp/tmp_Country_code); do
            echo -e "$(cat ./tmp/tmp_Country_code | sed -n '1p')"
            echo -e "$(cat ./tmp/tmp_Country_name | sed -n '1p')"
            echo -e "$(cat ./tmp/tmp_Country_code | sed -n '1p')"
            echo -e "$(bash /usr/local/bin/TorNet/scripts/country_flags.sh $j)"
            echo -e "$(cat ./tmp/tmp_Country_node | sed -n '1p')"
            sed -i '1d' ./tmp/tmp_Country_code
            sed -i '1d' ./tmp/tmp_Country_node
            sed -i '1d' ./tmp/tmp_Country_name

        done) --height=500 --width=400)

    if [[ "$?" == "0" ]]; then

        if [[ ! $select_server == "" ]]; then

            enabled_servers=$(cat ./tmp/server_list.csv | grep -i "$select_server" | awk '{print $1}' | cut -f 1 -d "," | wc -l)

            code=""
            code=$(cat ./tmp/server_list.csv | grep -i "$select_server" | awk '{print $1}' | cut -f 7 -d ",")

            cat ./tmp/server_list.csv | grep -i "$select_server" | awk '{print $1}' | cut -f 8 -d "," | tee ./tmp/_Ping_ 1 &>/dev/null
            cat ./tmp/server_list.csv | grep -i "$select_server" | awk '{print $1}' | cut -f 5 -d "," | tee ./tmp/_Speed_ 1 &>/dev/null
            cat ./tmp/server_list.csv | grep -i "$select_server" | awk '{print $1}' | cut -f 1 -d "," | tee ./tmp/_Hostname_ 1 &>/dev/null
            cat ./tmp/server_list.csv | grep -i "$select_server" | awk '{print $1}' | cut -f 3 -d "," | tee ./tmp/_Score_ 1 &>/dev/null

            Hostname_server=$(zenity --list --radiolist --window-icon="$icon" --title="servers: $select_server" --text="Активные сервера: $select_server  \n Всего $enabled_servers" \
                --column="Use" --column="Hostname" --column="~Speed Mb" --column="Session" --column="Score" --column="Code" --column="Flag" \
                $(for ((i = 0; i < $enabled_servers; i++)); do
                    echo -e "$(cat ./tmp/_Hostname_ | sed -n '1p')"
                    echo -e "$(cat ./tmp/_Hostname_ | sed -n '1p')"
                    echo -e "$(($(cat ./tmp/_Speed_ | sed -n '1p') / 1048576))"
                    echo -e "$(cat ./tmp/_Ping_ | sed -n '1p')"
                    echo -e "$(cat ./tmp/_Score_ | sed -n '1p')"
                    echo -e "$(bash /usr/local/bin/TorNet/scripts/country_flags.sh $code)"
                    sed -i '1d' ./tmp/_Hostname_
                    sed -i '1d' ./tmp/_Ping_
                    sed -i '1d' ./tmp/_Score_
                    sed -i '1d' ./tmp/_Speed_
                done) --height=600 --width=500)

            if [[ "$?" == "0" && "$Hostname_server" != "" ]]; then

                base64_vpn=$(cat ./tmp/server_list.csv | grep -i "$Hostname_server" | awk '{print $1}' | cut -f 15 -d ",")

                echo  "$base64_vpn" | base64 -di | tee /usr/local/bin/TorNet/source/server.ovpn 1 &>/dev/null

                # pkexec env DISPLAY="$DISPLAY" XAUTHORITY="$XAUTHORITY" bash /usr/local/bin/TorNet/scripts/vpngate_select.sh &

                # sleep 12 | zenity --window-icon="$icon" --progress --pulsate --title="Connect" --text="Run .. ." --no-cancel --width=300 --auto-close --auto-kill

                # if grep -q "Initialization Sequence Completed" /usr/local/bin/TorNet/tmp/vpn.log; then
                #     zenity --info --window-icon="$icon" --text="Initialization Sequence Completed"
                # elif grep -q "Options error: unknown --redirect-gateway flag: def" /usr/local/bin/TorNet/tmp/vpn.log; then
                #     zenity --error --window-icon="$icon" --text="Options error: unknown --redirect-gateway flag: def"
                #     TorNet 'select vpn'
                # elif grep -q "AUTH: Received control message: AUTH_FAILED" /usr/local/bin/TorNet/tmp/vpn.log; then
                #     zenity --error --window-icon="$icon" --text="AUTH: Received control message: AUTH_FAILED"
                #     TorNet 'select vpn'
                # else
                #     TorNet 'select vpn'
                # fi
            fi
        fi

    fi
else
    zenity --error --window-icon="$icon" --text="Неудалось загрузить список серверов "
fi

#finish
exit 0
