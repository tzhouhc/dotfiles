local wezterm = require 'wezterm'
local tabs = require 'settings/tabs'

local M = {}

local function is_osx()
  local f = io.popen("uname -a")
  return (f:read("*a") or ""):match("Darwin") == "Darwin"
end

function M.update_config(config)
  -- Minimal user interface
  -- still allow resizing with mouse
  config.window_decorations = "RESIZE"
  config.hide_tab_bar_if_only_one_tab = true

  -- visual appearance
  config.color_scheme = 'nord'

  if is_osx() then
    config.window_padding = {
      left = '0.5cell',
      right = '0.5cell',
      top = "1cell",
      bottom = '0cell'
    }
  end

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
