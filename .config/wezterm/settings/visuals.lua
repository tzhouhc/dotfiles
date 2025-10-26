local wezterm = require("wezterm")
require("settings/tabs")

local M = {}

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
    config.macos_fullscreen_extend_behind_notch = false
		config.window_padding = {
			left = "0cell",
			right = "0cell",
			top = "0cell",
			bottom = "0cell",
		}
	end

	-- font
	local cascadia = "Cascadia Code NF"
	local jetbrains = "JetBrainsMono Nerd Font Mono"
	-- interesting note: if a fallback font is not provided,
	-- then screen updates would take a lot of time trying to find replacements
	-- and cause "boxes" to remain on screen in the place of CJK characters.
	local pingfang = "PingFang SC"

	config.font = wezterm.font_with_fallback({
		{
			family = cascadia,
			harfbuzz_features = {
				-- ligatures
				"calt",
				-- cursive italics
				-- 'ss01=1',
				-- slashed zero
				"ss19",
				-- graphical control chars
				"ss20",
			},
		},
		{
			family = jetbrains,
		},
		{
			family = pingfang,
		},
	})
	config.font_rules = {
		-- Normal and Italic -- usually comments
		{
			intensity = "Normal",
			italic = true,
			font = wezterm.font_with_fallback({
				{
					-- a cursive font by design
					family = "Victor Mono",
					italic = true,
					weight = "Bold",
					-- see https://github.com/rubjo/victor-mono for stylistics.
					harfbuzz_features = { "ss02", "ss06", "ss07" },
				},
				{
					family = cascadia,
					italic = true,
					-- enable cursive italics
					harfbuzz_features = { "calt=1", "ss01=1", "ss19=1", "ss20=1" },
				},
				{
					family = pingfang,
				},
			}),
		},
	}
  if is_osx() then
    config.font_size = 13
  else
    config.font_size = 11
  end
end

return M
