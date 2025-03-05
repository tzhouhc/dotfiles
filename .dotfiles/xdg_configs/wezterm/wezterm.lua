-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- general settings
require'settings/common'.update_config(config)
require'settings/keys'.update_config(config)
require'settings/visuals'.update_config(config)
require'settings/tabs'.update_config(config)

-- additional configs that don't involve a config file
require'settings/events'
require'settings/commands'

-- additional interactions
-- for default window, open as fullscreen windowed mode
require'effects/start_maximized'
require'effects/nvim_zen_integ'

-- and finally, return the configuration to wezterm
return config
