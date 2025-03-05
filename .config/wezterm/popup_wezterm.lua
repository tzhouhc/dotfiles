-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- general settings
-- NOTE: removed startup behaviors to simplify term
require'settings/common'.update_config(config)
require'settings/keys'.update_config(config)
require'settings/visuals'.update_config(config)

-- NOTE: special configs for the popup aspect
config.initial_rows = 24
config.initial_cols = 120

-- and finally, return the configuration to wezterm
return config
