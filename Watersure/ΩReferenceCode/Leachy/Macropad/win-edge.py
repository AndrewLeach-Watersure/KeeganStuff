# SPDX-FileCopyrightText: 2021 Phillip Burgess for Adafruit Industries
#
# SPDX-License-Identifier: MIT

# MACROPAD Hotkeys example: Microsoft Edge web browser for Windows

from adafruit_hid.keycode import Keycode # REQUIRED if using Keycode.* values

app = {                      # REQUIRED dict, must be named 'app'
    'name' : 'Windows Edge', # Application name
    'macros' : [             # List of button macros...
        # COLOR    LABEL    KEY SEQUENCE
        # 1st row ----------
        (0x004000, '< Back', [Keycode.ALT, Keycode.LEFT_ARROW]),
        (0x004000, 'Fwd >', [Keycode.ALT, Keycode.RIGHT_ARROW]),
        (0x400000, 'Up', [Keycode.SHIFT, ' ']),      # Scroll up
        # 2nd row ----------
        (0x202000, '- Size', [Keycode.CONTROL, Keycode.KEYPAD_MINUS]),
        (0x202000, 'Size +', [Keycode.CONTROL, Keycode.KEYPAD_PLUS]),
        (0x400000, 'Down', ' '),                     # Scroll down
        # 3rd row ----------
        (0x000040, 'Reload', [Keycode.CONTROL, 'r']),
        (0x000040, 'Home', [Keycode.ALT, Keycode.HOME]),
        (0x000040, 'Private', [Keycode.CONTROL, 'N']),
        # 4th row ----------
        (0x000000, 'EAM', [Keycode.CONTROL, 'n', -Keycode.COMMAND,
                           'https://iosadm01.water.local/infor\n']),   # Adafruit in new window
        (0x800000, 'EAMTEST', [Keycode.CONTROL, 'n', -Keycode.COMMAND,
                            'https://ioscld01.water.local/infor\n']),   # Digi-Key in new window
        (0x101010, 'Home', [Keycode.CONTROL, 'n', -Keycode.COMMAND,
                             'https://intranet.water.local\n']), # Hack-a-Day in new win
        # Encoder button ---
        (0x000000, '', [Keycode.CONTROL, 'w']) # Close tab
    ]
}
