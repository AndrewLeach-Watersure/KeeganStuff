# MACROPAD Hotkeys example: Universal Numpad

from adafruit_hid.keycode import Keycode # REQUIRED if using Keycode.* values

app = {                    # REQUIRED dict, must be named 'app'
    'name' : 'Excel', # Application name
    'macros' : [           # List of button macros...
        # COLOR    LABEL    KEY SEQUENCE
        # 1st row ----------
        (0x4e6642, 'Home', [Keycode.CONTROL, Keycode.HOME]),
        (0x6b9656, 'Left', [Keycode.CONTROL, Keycode.LEFT_ARROW]),
        (0x4e6642, 'Up', [Keycode.CONTROL, Keycode.UP_ARROW]),
        # 2nd row ----------
        (0x4e6642, 'End', [Keycode.CONTROL, Keycode.SHIFT, Keycode.END]),
        (0x6b9656, 'Right', [Keycode.CONTROL, Keycode.RIGHT_ARROW]),
        (0x4e6642, 'Down', [Keycode.CONTROL, Keycode.DOWN_ARROW]),
        # 3rd row ----------
        (0xa1fa25, 'SelCol', [Keycode.CONTROL, Keycode.SPACEBAR]),
        (0xa1fa25, 'SelRow', [Keycode.SHIFT, Keycode.SPACEBAR]),
        (0x101010, 'FulScrn', [Keycode.CONTROL, Keycode.F1]),
        # 4th row ----------
        (0x129414, 'Insert', [Keycode.CONTROL, Keycode.SHIFT, Keycode.EQUALS]),
        (0xfa2562, 'Delete', [Keycode.CONTROL, Keycode.MINUS]),
        (0x34eb37, 'Save', [Keycode.CONTROL, Keycode.S]),
        # Encoder button ---
        (0x000000, '', [Keycode.BACKSPACE])
    ]
}
# Write your code here :-)
# Write your code here :-)