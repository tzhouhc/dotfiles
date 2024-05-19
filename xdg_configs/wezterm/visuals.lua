local wezterm = require 'wezterm'

local M = {}

function M.update_config(config)
  -- Minimal user interface
  -- still allow resizing with mouse
  config.window_decorations = "RESIZE"
  config.hide_tab_bar_if_only_one_tab = true

  -- visual appearance
  config.color_scheme = 'nord'

  -- font
  config.font = wezterm.font('Cascadia Code NF')
  config.font_size = 13
  config.harfbuzz_features = {
    -- ligatures
    'calt=1',
    -- cursive italics
    -- 'ss01=1',
    -- slashed zero
    'ss19=1',
    -- graphical control chars
    'ss20=1'
  }
end

return M
