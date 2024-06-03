local wezterm = require("wezterm")

local M = {}

function M.update_config(config)
	config.bypass_mouse_reporting_modifiers = "ALT"

	config.keys = {
		-- Turn off the default CMD-m Hide action
		{
			key = "m",
			mods = "CMD",
			action = wezterm.action.DisableDefaultAssignment,
		},
		{
			key = "q",
			mods = "CMD",
			action = wezterm.action({ CloseCurrentTab = { confirm = false } }),
		},
		{
			key = "Enter",
			mods = "SHIFT",
      action=wezterm.action{SendString="\x1b[13;2u"},
		},
		{
			key = "Enter",
			mods = "CTRL",
      action=wezterm.action{SendString="\x1b[13;5u"},
		},
	}
end

return M
