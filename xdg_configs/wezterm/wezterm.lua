-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- startup settings
require'startup'

-- general settings
require'common'.update_config(config)
require'keys'.update_config(config)
require'visuals'.update_config(config)

-- additional interactions
require'integrations'

-- and finally, return the configuration to wezterm
return config
