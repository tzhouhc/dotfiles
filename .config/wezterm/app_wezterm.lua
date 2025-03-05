-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- general settings
require 'settings/common'.update_config(config)
require 'settings/keys'.update_config(config)
require 'settings/visuals'.update_config(config)
require 'effects/no_tabs'.update_config(config)

-- non-fullscreen window setup
config.initial_rows = 48
config.initial_cols = 140
config.window_padding = {
  left = "0cell",
  right = "0cell",
  top = "0.3cell",
  bottom = "0cell",
}

-- additional interactions
require 'effects/nvim_zen_integ'
require 'effects/start_focused'

-- and finally, return the configuration to wezterm
return config
