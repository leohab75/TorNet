TorNet - это простая и понятная утилита для запуска Tor через proxy/socks5 или перенаправления всего .net трафика через сеть Tor. Так же, даёт возможность подключиться по OpenVPN к серверам VPN Gate по всему миру.
Работает на Fedora, Ubuntu, Arch; предпочтительно KDE.

(при запуске некоторых опции Tor будет запускаться окно xterm с отладочной информацией. Его можно смело закрывать...)

установка:

git clone https://github.com/leohab75/TorNet && cd TorNet/ && bash install.sh

[![Typing SVG](https://readme-typing-svg.herokuapp.com?color=%2336BCF7&lines=TorNet+use+Tor+and+VPNGate)](https://git.io/typing-svg)

В главном меню на вкладке интернет будут добавлены два ярлыка TorNet и Uninstall TorNet

GUI

![screen-gif](./TorNet_1.gif)

Tray

![screen-gif](./TorNet_3.gif)

terminal: TorNet + bash_completion

![screen-gif](./TorNet_2.gif)

как это работает:
 https://youtu.be/DxrPaEb3KeI

!если не заводится OpenVPN, то просто доустановите: https://unlix.ru/как-установить-openvpn-3-на-linux/