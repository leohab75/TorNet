#!/bin/bash

export GREEN='\033[1;92m'
export RED='\033[1;91m'
export RESETCOLOR='\033[1;00m'
export BLUE='\033[1;94m'

echo -e "\n$GREEN*$BLUE миграция во временный каталог \n$RESETCOLOR"
cd ../
cp -r TorNet/ /tmp/

echo -e "/tmp/TorNet \n"

#дадим разрешения ... release.sh => chown ...
echo -e "$GREEN"
echo -e "install TorNet for$BLUE USER: $RED"
echo -e "$USER" | tee /tmp/TorNet/_User_
echo -e "$RESETCOLOR"

#fix pep 668 python 3.11
cp "$HOME"/.config/pip/pip.conf "$HOME"/.config/pip/pip.conf.back
echo -e  "[global] \\n break-system-packages = true" > "$HOME"/.config/pip/pip.conf

#скрипт установки
pkexec bash /tmp/TorNet/release.sh

#for tray
python3 -m pip install --use-pep517 beautifulsoup4 psgtray pillow pystray pyqt5 --force-reinstall
python3 -m pip install -r /usr/local/bin/TorNet/scripts/proxy/requirements.txt

echo -e "\n$GREEN*$BLUE Удаляется временный каталог \n$RESETCOLOR"
rm -rf /tmp/TorNet

#ярлыки на рабочий стол
if [[ ! -f "$HOME"/'Рабочий стол'/TorNet ]]; then
    ln -s /usr/share/applications/TorNet.desktop "$HOME"/'Рабочий стол'/TorNet
fi

if [[ ! -d "/usr/local/bin/TorNet/tmp" ]]; then
    mkdir /usr/local/bin/TorNet/tmp
fi

TorNet="<span foreground='red' font='14'>T</span>orNet \n"

icon="/usr/local/bin/TorNet/source/icons/TorNet.png"
check_list=$(zenity --window-icon="$icon" --title="Optins" --text="$TorNet Почти готово ..." --list --checklist --separator=" " \
    --column="🔆" --column="key" --column="Описание" --hide-column=2 TRUE add_tray "Добавить TorNet в автозагрузку ??." \
    TRUE no_passwd "Отключить ввод пароля ..." --height=200 --width=350)

if [[ $? = "0" ]]; then

    for set in $check_list; do
        case $set in
        add_tray)

            if [[ ! -d "$HOME"/.config/autostart ]]; then
                mkdir "$HOME"/.config/autostart
            fi

            cp /usr/share/applications/TorNet.desktop "$HOME"/.config/autostart/
            sed -i 's:gui::g; s:Exec=:Exec=/usr/bin/sleep 10; :g' "$HOME"/.config/autostart/TorNet.desktop
            chmod +x "$HOME"/.config/autostart/TorNet.desktop
            ;;
        no_passwd)
            echo -e "\n$GREEN Правка: $RED /etc/sudoers.d/TorNet_no_passwd $RESETCOLOR\n"
            pkexec bash /usr/local/bin/TorNet/scripts/other/TorNet_no_passwd.sh
            ;;
        esac
    done
fi

if [[ -n $(grep -i "ubuntu" /etc/os-release) ]]; then
    #проверка файла приложения
    desktop-file-validate /usr/share/applications/TorNet.desktop
    desktop-file-validate /usr/share/applications/Uninstall_TorNet.desktop
else
    sed -i 's/debian-tor/tor/g' /usr/local/bin/TorNet/scripts/tor/TorNet_nat.sh
fi


#pep 668 
rm -f  "$HOME"/.config/pip/pip.conf
mv $HOME/.config/pip/pip.conf.back  "$HOME"/.config/pip/pip.conf


#completion
source /etc/bash_completion.d/TorNet

exit 0
