local wezterm = require("wezterm")

local M = {}

-- reference:
-- https://wezfurlong.org/wezterm/config/lua/window-events/format-tab-title.html

local SOLID_LEFT_PILL = wezterm.nerdfonts.ple_left_half_circle_thick
local SOLID_RIGHT_PILL = wezterm.nerdfonts.ple_right_half_circle_thick

local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

local function tab_icon(title)
	if title:find("tmux") then
		return ""
	elseif title:find("ellij") then -- hack since z could be cap or small
		return ""
	elseif title:find("vmware") then
		return "󰒔"
	elseif title:find("mbp") then
		return ""
	elseif title:find("gcp") then
		return "󱇶"
	elseif title:find("aws") then
		return ""
	elseif title:find("steam") then
		return "󰓓"
	else
		return ""
	end
end

local trp = "rgba(0, 0, 0, 0)"
local darker = "#38404f"
local dark = "#434c5e"
local gray = "#4c566a"

local bright = "#e5e9f0"
local cyan = "#88c0d0"
local green = "#a3be8c"
local red = "#e63333"
local yellow = "#e6cc33"
local lime = "#99e633"

local function tab_color(title)
	if title:find("tmux") then
		return green
	elseif title:find("ellij") then -- hack since z could be cap or small
		return green
	elseif title:find("vmware") then
		return cyan
	elseif title:find("mbp") then
		return lime
	elseif title:find("gcp") then
		return red
	elseif title:find("aws") then
		return yellow
	elseif title:find("steam") then
		return red
	else
		return green
	end
end

wezterm.on("format-tab-title", function(tab, _, _, _, hover, max_width)
	local title = tab_title(tab)
	local index = tab.tab_index + 1
	local icon = tab_icon(title)
	local edge_foreground, edge_background, background, foreground
	local main_color = tab_color(title)

	if tab.is_active then
		edge_foreground = trp
		edge_background = main_color
		background = dark
		foreground = bright
	elseif hover then
		edge_foreground = trp
		edge_background = bright
		background = dark
		foreground = bright
	else
		edge_foreground = trp
		edge_background = gray
		background = darker
		foreground = bright
	end

	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
	title = wezterm.truncate_right(title, max_width - 2)

	return {
		{ Background = { Color = edge_foreground } },
		{ Foreground = { Color = trp } },
		{ Text = " " },
		{ Background = { Color = trp } },
		{ Foreground = { Color = edge_background } },
		{ Text = SOLID_LEFT_PILL },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = "" .. index .. " " .. icon .. " " },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = "  " .. title .. " " },
		{ Background = { Color = trp } },
		{ Foreground = { Color = background } },
		{ Text = SOLID_RIGHT_PILL },
	}
end)

wezterm.on("update-status", function(gui_window, pane)
	local tabs = gui_window:mux_window():tabs()
	local mid_width = 0
	for idx, tab in ipairs(tabs) do
    -- this was *so* annoying to figure out
		local title = tab:active_pane():get_title()
		local idx_len = math.floor(math.log(idx, 10)) + 1
    local pill_len = 9 + idx_len + #title
		mid_width = mid_width + pill_len + 1
	end
	local tab_width = gui_window:active_tab():get_size().cols
	local max_left = tab_width / 2 - mid_width / 2

	gui_window:set_left_status(wezterm.pad_left(" ", max_left))
	gui_window:set_right_status("")
end)

local tab_colors = {
	background = trp,

	new_tab = {
		bg_color = "#2E3440",
		fg_color = "#434C5E",
	},
	new_tab_hover = {
		bg_color = "#81A1C1",
		fg_color = "#2E3440",
		italic = true,
	},
}

function M.update_config(config)
	config.tab_bar_at_bottom = true
	config.use_fancy_tab_bar = false
	config.show_new_tab_button_in_tab_bar = false
	config.tab_bar_at_bottom = false
	if config["colors"] then
		config.colors["tab_bar"] = tab_colors
	else
		config.colors = {
			tab_bar = tab_colors,
		}
	end
end

return M
