local wezterm = require("wezterm")
require("settings/tabs")

local M = {}

-- Issue: does not handle nerdfont
local function is_osx()
	local f = io.popen("uname -a")
	return (f:read("*a") or ""):match("Darwin") == "Darwin"
end

function M.update_config(config)
	-- Minimal user interface
	-- still allow resizing with mouse
	config.window_decorations = "RESIZE"
	config.hide_tab_bar_if_only_one_tab = true

	-- visual appearance
	config.color_scheme = "nord"
	config.window_background_opacity = 1

	if is_osx() then
		config.window_padding = {
			left = "0.3cell",
			right = "0cell",
			top = "1cell",
			bottom = "0cell",
		}
	end

	-- font
	local scientifica = "scientifica"
	-- interesting note: if a fallback font is not provided,
	-- then screen updates would take a lot of time trying to find replacements
	-- and cause "boxes" to remain on screen in the place of CJK characters.
	local dinkie = "DinkieBitmap"

	config.font = wezterm.font_with_fallback({
		{
			family = scientifica,
		},
		{
			family = dinkie,
		},
	})
  if is_osx() then
    config.font_size = 15
  else
    config.font_size = 13
  end
end

return M
