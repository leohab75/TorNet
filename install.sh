#!/bin/bash

export GREEN='\033[1;92m'
export RED='\033[1;91m'
export RESETCOLOR='\033[1;00m'
export BLUE='\033[1;94m'

echo -e "\n$GREEN*$BLUE миграция во временный каталог \n$RESETCOLOR"
cd ../
cp -R TorNet/ /tmp/

echo -e "/tmp/TorNet \n"

#дадим разрешения ... release.sh => chown ...
echo -e "$GREEN"
echo -e "install TorNet for$BLUE USER: $RED"
echo -e "$USER" | tee /tmp/TorNet/_User_
echo -e "$RESETCOLOR"

#скрипт установки
pkexec bash /tmp/TorNet/release.sh

#согласно pep 688
cd /usr/local/bin/TorNet/ || echo "$RED ERR: $BLUE могут быть проблемы с зависимостями python $RESETCOLOR"
python3 -m venv /usr/local/bin/TorNet/venv
source /usr/local/bin/TorNet/venv/bin/activate

pip install --upgrade pip wheel setuptools

#for tray and gui
pip install pystray Pillow PyGObject  PyQt6
#for proxy
pip install  -r /usr/local/bin/TorNet/scripts/proxy/requirements.txt 
#for speedtest
pip install speedtest-cli

deactivate

#fonts
if [[ ! -d $HOME/.fonts ]]; then
    mkdir $HOME/.fonts
fi

cp -r "/usr/local/bin/TorNet/source/fonts/" "$HOME/.fonts"
fc-cache -f

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
    TRUE no_passwd "Отключить ввод пароля ..." --height=300 --width=450)

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

exit 0
