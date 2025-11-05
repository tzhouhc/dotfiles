local hotkey = require("hs.hotkey")

local apps = require("apps")
local windows = require("windows")

-- window manipulation a la Rectangle / Spectacle
hotkey.bind({ "alt", "ctrl" }, "Right", windows.right_half)
hotkey.bind({ "alt", "ctrl" }, "Left", windows.left_half)
hotkey.bind({ "alt", "ctrl" }, "Return", windows.maximize)
hotkey.bind({ "alt", "ctrl" }, "Down", windows.bottom_half)
hotkey.bind({ "alt", "ctrl" }, "Up", windows.top_half)
hotkey.bind({ "alt", "ctrl" }, "q", windows.top_left_quadrant)
hotkey.bind({ "alt", "ctrl" }, "r", windows.top_right_quadrant)
hotkey.bind({ "alt", "ctrl" }, "z", windows.bottom_left_quadrant)
hotkey.bind({ "alt", "ctrl" }, "c", windows.bottom_right_quadrant)

-- application shortcuts
hs.hotkey.bind({ "cmd" }, "`", apps.toggle_wizterm)
hs.hotkey.bind({ "alt", "ctrl" }, "space", apps.summon_quick_open)
hs.hotkey.bind({ "alt" }, "`", apps.summon_quick_chat)
