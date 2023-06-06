#!/usr/bin/python3


from PyQt6.QtWidgets import *
from PyQt6.QtGui import QIcon
import sys
import os


class App(QMainWindow):

    def __init__(self):
        super().__init__()

        # Set window properties
        self.setWindowTitle("TorNet")
        self.setGeometry(100, 100, 233, 400)

        # Create tab widget
        self.tabs = QTabWidget(self)
        self.tabs.setGeometry(5, 5, 223, 390)

        # style
        self.setWindowIcon(
            QIcon('/usr/local/bin/TorNet/source/icons/TorNet.png'))

        self.tabs.setStyleSheet(
            "background-color :  rgb(32,32,32) ; border : 1px solid rgb(47,79,79); font-size: 14px")

        self.tab_a = QWidget()
        self.tab_b = QWidget()
        self.tab_c = QWidget()
        self.tab_d = QWidget()

        self.tabs.addTab(self.tab_a, f'Tor')
        self.tabs.addTab(self.tab_b, f'VPN')
        self.tabs.addTab(self.tab_c, f'Proxy')
        self.tabs.addTab(self.tab_d, f'Other')

        # self.setCentralWidget(self.tabs)

        # Create buttons for each tab
        self.create_buttons(
            self.tab_a, ["Start Tor", "Stop Tor", "Tor socks5"], 3, ["Запускает Tor через NAT \n!!!изменяет iptables",
                                                                     "Отключает Tor \n восстанавливает iptabless", "Запускает Tor Snowflake-client \nтолько socks5 proxy \nIP 127.0.0.1 Port 2323"])
        self.create_buttons(
            self.tab_b, ["Start VPN select", "Stop all VPN", "Favorite", "Add to favorite"], 4, ["Подключить клиент к\n VPNGate OpenVPN \n!!!изменяет iptables -t nat",
                                                                                                 "Выключить OpenVPN\n восстанавливает iptables", "список избранного \nвозможно подключение", "Добавить сервер в избранное \nтолько для текущего подключения"])
        self.create_buttons(
            self.tab_c, ["HTTPs", "HTTP", "Socks5"], 3, ["Скраббер HTTPs", "Скраббер HTTP", "Скраббер socks5 \n!!!долго думает"])
        self.create_buttons(
            self.tab_d, ["TorNet", "Check IP", "speedtest"], 3, ["Открывает страницу на GitHub", "Показывает информацию по текущему IP", "Проверяет скорость загрузки файла"])

        self.label_text = QLabel(self)
        self.label_text.setGeometry(20, 330, 193, 25)
        self.label_text.setStyleSheet(
            "background-color :  rgb(32,32,32) ; hover; font-size: 12px; color white")
        self.label_text.setText("terminal run:")

        self.label = QLabel(self)
        self.label.setGeometry(20, 360, 193, 25)
        self.label.setStyleSheet(
            "background-color :  rgb(18,25,28) ; border : 1px solid rgb(47,79,71); font-size: 14px; color: rgb(0,155,118)")

        self.label_tor = QLabel(self.tab_a)
        self.label_tor.setGeometry(5, 5, 80, 45)
        self.label_tor.setStyleSheet(
            "background-color :  rgb(32,32,32) ; border : 1px solid rgb(32,32,32); font-size: 40px; font-family: Feena Casual; color: white")
        self.label_tor.setText("ToR")

        self.label_tor = QLabel(self.tab_a)
        self.label_tor.setGeometry(5, 195, 200, 100)
        self.label_tor.setStyleSheet(
            "background-color :  rgb(32,32,32) ; border : 1px solid rgb(32,32,32); font-size: 100px; font-family: Komedy Kritters; color: rgb(205,133,63)")
        self.label_tor.setText("GF")

        self.label_vpn = QLabel(self.tab_b)
        self.label_vpn.setGeometry(5, 5, 180, 45)
        self.label_vpn.setStyleSheet(
            "background-color :  rgb(32,32,32) ; border : 1px solid rgb(32,32,32); font-size: 40px; font-family: Feena Casual; color: white")
        self.label_vpn.setText("VPN Gate")

        self.label_vpn = QLabel(self.tab_b)
        self.label_vpn.setGeometry(120, 250, 85, 50)
        self.label_vpn.setStyleSheet(
            "background-color :  rgb(32,32,32) ; border : 1px solid rgb(32,32,32); font-size: 50px; font-family: Komedy Kritters; color: rgb(205,133,63)")
        self.label_vpn.setText("C")

        self.label_proxy = QLabel(self.tab_c)
        self.label_proxy.setGeometry(5, 5, 180, 50)
        self.label_proxy.setStyleSheet(
            "background-color :  rgb(32,32,32) ; border : 1px solid rgb(32,32,32); font-size: 40px; font-family: Feena Casual; color: white")
        self.label_proxy.setText("Use ProXY")

        self.label_proxy = QLabel(self.tab_c)
        self.label_proxy.setGeometry(15, 195, 200, 100)
        self.label_proxy.setStyleSheet(
            "background-color :  rgb(32,32,32) ; border : 1px solid rgb(32,32,32); font-size: 100px; font-family: Komedy Kritters; color: rgb(205,133,63)")
        self.label_proxy.setText("da")

        self.label_other = QLabel(self.tab_d)
        self.label_other.setGeometry(5, 5, 120, 45)
        self.label_other.setStyleSheet(
            "background-color :  rgb(32,32,32) ; border : 1px solid rgb(32,32,32); font-size: 40px; font-family: Feena Casual; color: white")
        self.label_other.setText("TorNet")

        self.label_other = QLabel(self.tab_d)
        self.label_other.setGeometry(5, 195, 200, 100)
        self.label_other.setStyleSheet(
            "background-color :  rgb(32,32,32) ; border : 1px solid rgb(32,32,32); font-size: 100px; font-family: Komedy Kritters; color: rgb(205,133,63)")
        self.label_other.setText("OU")

    def create_buttons(self, tab, text, num, dict):
        for i in range(num):
            button = QPushButton(text[i], tab)
            button.setGeometry(33, 60 + i*50, 150, 30)
            button.clicked.connect(self.on_button_clicked)
            button.setStyleSheet("QPushButton { background-color: lightblue; color: red }"
                                 "QPushButton:pressed { background-color: purple }")
            button.setToolTip(str(dict[i]))

    def on_button_clicked(self):
        sender = self.sender()
        text = sender.text()
        os.system('echo "Button {} clicked"'.format(text))
        # TOR
        if text == "Start Tor":
            run_comand = "/usr/bin/TorNet 'start_tor'"
            self.label.setText(run_comand)
            os.system(f'/bin/bash  {run_comand} &')
        elif text == "Stop Tor":
            run_comand = "/usr/bin/TorNet stop_tor"
            self.label.setText(run_comand)
            os.system(f'/bin/bash  {run_comand} &')
        elif text == "Tor socks5":
            run_comand = "/usr/bin/TorNet proxy_tor"
            self.label.setText(run_comand)
            os.system(f'/bin/bash  {run_comand} &')
        # VPN
        elif text == "Start VPN select":
            run_comand = "/usr/bin/TorNet start_vpn"
            self.label.setText(run_comand)
            os.system(f'/bin/bash  {run_comand} &')
        elif text == "Stop all VPN":
            run_comand = "/usr/bin/TorNet stop_vpn"
            self.label.setText(run_comand)
            os.system(f'/bin/bash  {run_comand} &')
        elif text == "Favorite":
            os.system(
                "bash /usr/local/bin/TorNet/scripts/vpn/vpngate_favorite.sh &")
        elif text == "Add to favorite":
            os.system(
                "bash /usr/local/bin/TorNet/scripts/vpn/vpngate_check.sh 'choice' &")
        # Other
        elif text == "TorNet":
            self.label.setText("xdg-open https://github...")
            os.system("xdg-open https://github.com/leohab75/TorNet")
        elif text == "Check IP":
            run_comand = "/usr/bin/TorNet status"
            self.label.setText(run_comand)
            os.system(f'/bin/bash  {run_comand} &')
        elif text == "speedtest":
            run_comand = "/usr/bin/TorNet speedtest"
            self.label.setText(run_comand)
            os.system(f'/bin/bash  {run_comand} &')
        # ProXY
        elif text == "HTTP":
            run_comand = "/usr/bin/TorNet http_proxy"
            self.label.setText(run_comand)
            os.system(f'/bin/bash  {run_comand} &')
        elif text == "HTTPs":
            run_comand = "/usr/bin/TorNet https_proxy"
            self.label.setText(run_comand)
            os.system(f'/bin/bash  {run_comand} &')
        elif text == "Socks5":
            run_comand = "/usr/bin/TorNet socks5_proxy"
            self.label.setText(run_comand)
            os.system(f'/bin/bash  {run_comand} &')
        else:
            print("no implementation.. !!")


if __name__ == '__main__':
    import sys
    app = QApplication(sys.argv)
    a = App()
    a.setStyleSheet("background-color: black;")
    a.show()
    sys.exit(app.exec())
