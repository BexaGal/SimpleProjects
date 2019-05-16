#           ---PINGNOTIFICATOR 1.0 (for Windows)---
#   This script pings a sertain URL to check internet connection
#   If "ping" returns an issue, you get a notification telling you about the problem.
#   Author - BexaGal
#   ________________
#   This is my first try to write a script solving practical tasks. In next projects I want to do more cool and needed things.
#   If you send advices, I will be happy.
#   ^-^


from win10toast import ToastNotifier
import subprocess
pnot = ToastNotifier()
while True:    
    if subprocess.call("ping ya.ru") != 0:
        pnot.show_toast("WARNING", "INTERNET CONNECTION NOT FOUND!")
        print(" ")
        print("WARNING, INTERNET CONNECTION NOT FOUND. PLEASE, CHECK ROUTER, CABLE CONNECTION OR ANOTHER THINGS.")
        print("Type STOP to end the program or press ENTER to run program again.")
        if input("Your input: ").lower() == "stop":
            print("Program execution is stopped. Good luck in solving connection issues.")
            exit()
