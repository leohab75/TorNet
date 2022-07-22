#!/bin/bash

export GREEN='\033[1;92m'
export RED='\033[1;91m'
export RESETCOLOR='\033[1;00m'
export BLUE='\033[1;94m'

echo -e "\n$GREEN*$BLUE миграция во временный каталог \n$RESETCOLOR"
cd ../
cp -r TorNet/ /tmp/

echo -e "/tmp/TorNet \n"

#дадим разрешения ... releade.sh => chown ...
echo -e "$GREEN"
echo -e "install TorNet for$BLUE USER: $RED"
echo -e "$USER" | tee /tmp/TorNet/_User_
echo -e "$RESETCOLOR"

#скрипт установки
pkexec bash /tmp/TorNet/release.sh

#xterm color setting
cp /tmp/TorNet/source/.Xresources "$HOME"
xrdb -merge "$HOME"/.Xresources

#for tray
python3 -m pip install --upgrade --no-cache-dir psgtray pillow pystray

echo -e "\n$GREEN*$BLUE Удаляется временный каталог \n$RESETCOLOR"
rm -rf /tmp/TorNet

#ярлыки на рабочий стол
if [[ ! -f "$HOME"/'Рабочий стол'/TorNet ]]; then
    ln -s /usr/share/applications/TorNet.desktop "$HOME"/'Рабочий стол'/TorNet
fi

if [[ ! -d "/usr/local/bin/TorNet/tmp" ]]; then
    mkdir /usr/local/bin/TorNet/tmp
fi

if [[ -n $(grep -i "ubuntu" /etc/os-release) ]]; then

    icon="/usr/local/bin/TorNet/source/icons/TorNet.png"
    check_list=$(zenity --window-icon="$icon" --title="Optins" --text="Почти готово ..." --list --checklist --separator=" " \
        --column="Use" --column="key" --column="Описание" --hide-column=2 TRUE add_tray "Добавить TorNet в автозагрузку ??." \
        TRUE no_passwd "Отключить ввод пароля ..." --height=185 --width=350)

    if [[ $? = "0" ]]; then

        for set in $check_list; do
            case $set in
            add_tray)

                if [[ ! -d "$HOME"/.config/autostart ]]; then
                    mkdir "$HOME"/.config/autostart
                fi

                cp /usr/share/applications/TorNet.desktop "$HOME"/.config/autostart/
                sed -i 's:Gui::g; s:Exec=:Exec=/usr/bin/sleep 10; :g' "$HOME"/.config/autostart/TorNet.desktop
                ;;
            no_passwd)
                echo -e "\n$GREEN Правка: $RED /etc/sudoers.d/TorNet_no_passwd $RESETCOLOR\n"
                pkexec bash /usr/local/bin/TorNet/scripts/TorNet_no_passwd.sh
                ;;
            esac
        done
    fi

    #проверка файла приложения
    desktop-file-validate /usr/share/applications/TorNet.desktop
    desktop-file-validate /usr/share/applications/Uninstall_TorNet.desktop
fi

exit 0
