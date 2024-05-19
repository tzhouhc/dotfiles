-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

require'visuals'.update_visuals(config)

-- and finally, return the configuration to wezterm
return config
