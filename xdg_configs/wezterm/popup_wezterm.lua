-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- general settings
require'common'.update_config(config)
require'keys'.update_config(config)
require'visuals'.update_config(config)

local mux = wezterm.mux
-- start and acquire focus
wezterm.on('gui-startup', function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():focus()
end)

config.initial_rows = 24
config.initial_cols = 120

-- and finally, return the configuration to wezterm
return config
