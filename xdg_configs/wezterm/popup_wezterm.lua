-- Pull in the wezterm API
local wezterm = require 'wezterm'
local mux = wezterm.mux

-- This will hold the configuration.
local config = wezterm.config_builder()

-- general settings
-- NOTE: removed startup behaviors to simplify term
require'common'.update_config(config)
require'keys'.update_config(config)
require'visuals'.update_config(config)

-- NOTE: special configs for the popup aspect
config.initial_rows = 24
config.initial_cols = 120

-- and finally, return the configuration to wezterm
return config
