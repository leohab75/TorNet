#!/usr/bin/env bash

if [[ ! -n $(pidof tor) ]]; then

    cd /usr/local/bin/TorNet/scripts/tor/tor-relay-scanner || zenity --error text="error path\n /usr/local/bin/bin/TorNet/scripts/tor/tor-relay-scanner"

    if [[ ! -f torparse.pyz ]]; then
        bash build.sh
    fi

    python3 torparse.pyz --torrc -o /usr/local/bin/TorNet/scripts/tor/bridges.conf

    sed -i '/UseBridges/d' /usr/local/bin/TorNet/scripts/tor/bridges.conf
    tor -f /usr/local/bin/TorNet/scripts/tor/torrc | tee tor.log &

    xrdb /usr/local/bin/TorNet/source/.Xdefaults
    xterm -e "tail -f tor.log | stdbuf -oL cut -d ' ' -f5-  " &

    while true; do

        sleep 5
        if grep -q "Bootstrapped 100%" tor.log; then

            sleep 10

            if grep -q "Not attempting connection" tor.log; then

                zenity --notification --text="Tor Relay reload"
                TorNet stop_tor
                TorNet start_tor

            else
                zenity --notification --text="Tor Relay enabled"
                break
            fi
        fi
    done

else
    TorNet stop_tor
    TorNet start_tor

fi
