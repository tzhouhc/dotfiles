local wezterm = require("wezterm")
require("settings/tabs")

local M = {}

-- font
local cascadia = "Cascadia Code NF"
local jetbrains = "JetBrainsMono Nerd Font Mono"
-- interesting note: if a fallback font is not provided,
-- then screen updates would take a lot of time trying to find replacements
-- and cause "boxes" to remain on screen in the place of CJK characters.
local pingfang = "PingFang SC"
local scientifica = "scientifica"
local victor = "Victor Mono"

local function is_osx()
	local f = io.popen("uname -a")
	return (f:read("*a") or ""):match("Darwin") == "Darwin"
end

M.main_font = cascadia
M.italic_font = victor
M.main_size = 13
M.sys_default = pingfang

function M.update_config(config)
	-- Minimal user interface
	-- still allow resizing with mouse
	config.window_decorations = "RESIZE"
	config.hide_tab_bar_if_only_one_tab = true

	-- visual appearance
	config.color_scheme = "Catppuccin Frappe"
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

	config.font = wezterm.font_with_fallback({
		{
			family = M.main_font,
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
			family = M.sys_default,
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
					family = M.italic_font,
					italic = true,
					weight = "Bold",
					-- see https://github.com/rubjo/victor-mono for stylistics.
					harfbuzz_features = { "ss02", "ss06", "ss07" },
				},
				{
					family = M.main_font,
					italic = true,
					-- enable cursive italics
					harfbuzz_features = { "calt=1", "ss01=1", "ss19=1", "ss20=1" },
				},
				{
          family = M.sys_default,
				},
			}),
		},
	}
	if is_osx() then
		config.font_size = M.main_size
	else
		config.font_size = M.main_size - 2
	end
end

wezterm.on("window-config-reloaded", function(window)
	if wezterm.gui.screens().active.name == "ASM-160QC" then
		window:set_config_overrides({
			font_size = 11,
		})
	end
end)

wezterm.on("switch-core-font", function(window, _)
	local cfg = window:get_config_overrides() or {}
	if M.main_font == cascadia then
		M.main_font = scientifica
		M.italic_font = scientifica
		M.main_size = 16
	else
		M.main_font = cascadia
		M.italic_font = victor
		M.main_size = 13
	end
	M.update_config(cfg)
	window:set_config_overrides(cfg)
end)

return M
