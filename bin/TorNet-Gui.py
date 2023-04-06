import sys, os
from PyQt5.QtWidgets import QApplication, QMainWindow, QTabWidget, QWidget, QPushButton
from functools import partial

 



class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()

        # Set window properties
        self.setWindowTitle("TorNet")
        self.setGeometry(100, 100, 262, 448)

        # Create tab widget
        self.tabs = QTabWidget(self)
        self.tabs.setGeometry(10, 10, 242, 435)

        # Create tabs
        self.tab1 = QWidget()
        self.tab2 = QWidget()
        self.tab3 = QWidget()

        # Add tabs to tab widget
        self.tabs.addTab(self.tab1, "Tor")
        self.tabs.addTab(self.tab2, "VPN")
        self.tabs.addTab(self.tab3, "Other")

        # Create buttons for each tab
        self.create_buttons(self.tab1, ["Start Tor", "Stop Tor", "Socks5"], 3)
        self.create_buttons(self.tab2, ["Start VPN select", "Stop all VPN", "Favorite", "Add to favorite"], 4)
        self.create_buttons(self.tab3, ["TorNet", "Proxy Https", "Check IP"], 3)

        self.setStyleSheet("background-image : url(/usr/local/bin/TorNet/source/icons/Icon/Tornet.png) ; border : 1px solid green")



    def create_buttons(self, tab, button_names, num_buttons):
        for i in range(num_buttons):
            button = QPushButton(button_names[i], tab)
            button.setGeometry(40, 50 + i*50, 150, 30)
            button.clicked.connect(partial(self.button_clicked, button.text(), tab.windowTitle(), ))

    def button_clicked(self, button_name, tab_name):
        os.system(f"echo '{button_name}' is tab '{tab_name}'")
        if button_name == "Start Tor" :
            self.setStyleSheet("background-image : url(/usr/local/bin/TorNet/source/icons/Icon/start_tor.png) ; border : 1px solid white")
            os.system("bash /usr/bin/TorNet 'start_tor' &")
        elif button_name == "Stop Tor" :
            self.setStyleSheet("background-image : url(/usr/local/bin/TorNet/source/icons/Icon/stop_tor.png) ; border : 1px solid yellow")
            os.system("bash /usr/bin/TorNet 'stop_tor' &")
        elif button_name == "Socks5" :
            self.setStyleSheet("background-image : url(/usr/local/bin/TorNet/source/icons/Icon/socks5.png) ; border : 1px solid grey")
            os.system("bash /usr/bin/TorNet 'proxy_tor' &")
        elif button_name == "Start VPN select" :
            self.setStyleSheet("background-image : url(/usr/local/bin/TorNet/source/icons/Icon/start_vpn.png) ; border : 1px solid white")
            os.system("bash /usr/local/bin/TorNet/scripts/vpn/vpngate_select_gui.sh &")
        elif button_name == "Stop all VPN" :
            self.setStyleSheet("background-image : url(/usr/local/bin/TorNet/source/icons/Icon/stop_vpn.png) ; border : 1px solid yellow")
            os.system("bash /usr/bin/TorNet 'stop_vpn' &")
        elif button_name == "Favorite" :
            self.setStyleSheet("background-image : url(/usr/local/bin/TorNet/source/icons/Icon/favorite.png) ; border : 1px solid grey")
            os.system("bash /usr/local/bin/TorNet/scripts/vpn/vpngate_favorite.sh &")
        elif button_name == "Add to favorite" :
            self.setStyleSheet("background-image : url(/usr/local/bin/TorNet/source/icons/Icon/add_to.png) ; border : 1px solid grey")
            os.system("bash /usr/local/bin/TorNet/scripts/vpn/vpngate_check.sh 'choice' &")
        elif button_name == "TorNet" :
            self.setStyleSheet("background-image : url(/usr/local/bin/TorNet/source/icons/Icon/Tornet.png) ; border : 1px solid green")
            os.system("xdg-open https://github.com/leohab75/TorNet")
        elif button_name == "Proxy Https" :
            self.setStyleSheet("background-image : url(/usr/local/bin/TorNet/source/icons/Icon/proxy.png) ; border : 1px solid orange")
            os.system("bash /usr/bin/TorNet 'gui_proxy' &")
        elif button_name == "Check IP" :
            self.setStyleSheet("background-image : url(/usr/local/bin/TorNet/source/icons/Icon/check.png) ; border : 1px solid grey")
            os.system("bash /usr/bin/TorNet 'status' &")
        else :
            print("no implementation.. !!")


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec_())
