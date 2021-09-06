import os
from evdev import InputDevice, categorize, ecodes
dev = InputDevice('/dev/input/event18')
dev.grab()
os.system('clear')
for event in dev.read_loop():
    if event.type == ecodes.EV_KEY:
        key = categorize(event)
        if key.keystate == key.key_down:
            if key.keycode == 'KEY_ESC':
                os.system('echo Hello World')
            elif key.keycode == 'KEY_X':
                os.system('xdotool type "lmao xd lol rofl ialmaorn roflmao XD lawl Cx" && xdotool key Return')
            elif key.keycode == 'KEY_S':
                os.system('steam &')
            elif key.keycode == 'KEY_D':
                os.system('discord-canary &')
            elif key.keycode == 'KEY_F':
                os.system('firefox-nightly &')
            elif key.keycode == 'KEY_Q':
                os.system('qutebrowser &')
            elif key.keycode == 'KEY_N':
                os.system('xdotool type "England is my city." && xdotool key Return')
            elif key.keycode == 'KEY_L':
                os.system('lutris &')
            elif key.keycode == 'KEY_P':
                os.system('pavucontrol &')
            elif key.keycode == 'KEY_M':
                os.system('xdotool key Scroll_Lock')
            elif key.keycode == 'KEY_1':
                os.system('xdotool key Super+1')
            elif key.keycode == 'KEY_A':
                os.system('xdotool type "btw i use arch" && xdotool key Return')