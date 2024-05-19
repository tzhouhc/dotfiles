local wezterm = require 'wezterm'

local M = {}

function M.update_visuals(config)
  -- Minimal user interface
  -- still allow resizing with mouse
  config.window_decorations = "RESIZE"
  config.hide_tab_bar_if_only_one_tab = true

  -- visual appearance
  config.color_scheme = 'nord'

  -- font
  config.font = wezterm.font('Cascadia Code NF')
end

return M
