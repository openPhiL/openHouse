# Light Control

## Overview

All of my rooms follow the same principle when it comes to lights. I work with light scenes. e.g. ("everyhting off", "everything ON and bright", "Romantic" ... ).

Those Scenes are set automatically when:

- group of presence sensors change
- luminance of the room changes below a value set by a settingItem
- when the manual timer runs out

Automatically means:

- ON:  it will change the scene according to the time of day,
- OFF: it will change to the scene "everything off"

Manually changing the scene is also possible. This command will initialize a manual timer to 20min. If this one runs out to 0, scene will automatically change to "everything off".

Please see the available demo-files, comments are included.
