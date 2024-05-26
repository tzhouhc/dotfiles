-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- general settings
require'settings/common'.update_config(config)
require'settings/keys'.update_config(config)
require'settings/visuals'.update_config(config)
require'settings/tabs'.update_config(config)

-- additional interactions
-- for default window, open as fullscreen windowed mode
require'effects/start_maximized'
-- TODO: debug this
-- interactions with nvim zen mode
require'effects/nvim_zen_integ'

-- and finally, return the configuration to wezterm
return config
