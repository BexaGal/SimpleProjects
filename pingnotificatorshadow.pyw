#           ---SHADOW PINGNOTIFICATOR 1.0 (for Windows)---
#   This script pings a sertain URL to check internet connection
#   If "ping" returns an issue, you get a notification telling you about the problem.
#   This version works on background, so any print() wouldn't work, obviously.
#   Here I used "time" module to pause the ping.
#   Author - BexaGal
#   ________________
#   Any advices and upgrades are welcome.
#   ^-^

from win10toast import ToastNotifier
import subprocess, time
pnot = ToastNotifier()
while True:    
    with subprocess.Popen("ping ya.ru", creationflags=subprocess.CREATE_NO_WINDOW) as ping:
        if ping.wait() != 0:
            pnot.show_toast("WARNING", "INTERNET CONNECTION NOT FOUND!")
            time.sleep(1)