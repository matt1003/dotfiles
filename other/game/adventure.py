import atexit
import json
import os
import sys
import termios
import time
import tty

def terminal_echo(enabled):
    fd = sys.stdin.fileno()
    (iflag, oflag, cflag, lflag, ispeed, ospeed, cc) = termios.tcgetattr(fd)
    if enabled:
        lflag |= termios.ECHO
    else:
        lflag &= ~termios.ECHO
    new_attr = [iflag, oflag, cflag, lflag, ispeed, ospeed, cc]
    termios.tcsetattr(fd, termios.TCSANOW, new_attr)

def get_single_char():
    fd = sys.stdin.fileno()
    old_settings = termios.tcgetattr(fd)
    try:
        tty.setraw(fd)
        char = sys.stdin.read(1)
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
    return char

def get_single_int():
    while True:
        char = get_single_char()
        if char.isdigit():
            return int(char)

def print_slow(string):
    for char in string:
        time.sleep(0.01)
        if char == "\n":
            char = "\n "
        print(char, end="", flush=True)

def get_password(prompt):
    print(prompt, end='', flush=True)
    buf = b''
    while True:
        char = get_single_char().encode(encoding='utf-8')
        if char in {b'\n', b'\r', b'\r\n'}:
            print('')
            break
        else:
            buf += char
            print('*', end='', flush=True)
    return buf.decode(encoding='utf-8')

class Card:
    def __init__(self, data):
        self.option = data["option"]
        self.story = data["story"]
        self.next = []
        if "next" in data:
            for option in data["next"]:
                self.next.append(Card(option))

    def display(self):
        os.system("clear")
        print_slow("\n{}\n".format(self.story))
        time.sleep(0.25)
        for idx, option in enumerate(self.next):
            print_slow("  {}: {}\n".format(idx+1, option.option))
            time.sleep(0.25)

    def next_card(self):
        print_slow("\nChoice: ")
        while True:
            selection = get_single_int()
            if selection > 0 and selection <= len(self.next):
                print(selection)
                time.sleep(0.5)
                return self.next[selection-1]

    def get_restart_or_exit(self):
        print_slow("\nChoice: ")
        while True:
            selection = get_single_char()
            if selection == "r" or selection == "e":
                print(selection)
                time.sleep(0.5)
                return selection

    def last(self):
        print_slow("\nFin.\n  r: restart\n  e: exit\n")
        selection = self.get_restart_or_exit()
        os.system("clear")
        return selection

    def play(self):
        self.display()
        if self.next:
            return self.next_card().play()
        else:
            return self.last()

atexit.register(terminal_echo, True)

adventures = [f for f in os.listdir('.') if f.endswith('.json')]

terminal_echo(enabled=False)

while True:

    os.system("clear")
    print_slow("\nWelcome!\n\nIn which adventure do you wish to partake?\n")

    for idx, option in enumerate(adventures):
        print_slow("  {}: {}\n".format(idx+1, os.path.splitext(option)[0]))
        time.sleep(0.25)
    
    print_slow("\nChoice: ")

    while True:
        selection = get_single_int()
        if selection > 0 or selection <= len(adventures):
            break

    print(selection)
    time.sleep(0.5)

    while True:
        os.system("clear")
        print_slow("\nPassword is required!\n\n")
        password = get_password("Password: ")
        if password != "laura":
            print_slow("\nInvalid passowrd!")
            time.sleep(1.5)
        else:
            print_slow("\nCorrect!")
            time.sleep(1.5)
            break

    with open(adventures[selection-1], "r") as f:
        data = json.load(f)

    if Card(data).play() == "e":
        break

