local wezterm = require 'wezterm'

local M = {}

function M.update_config(config)
  config.bypass_mouse_reporting_modifiers = 'ALT'

  config.keys = {
    -- Turn off the default CMD-m Hide action
    {
      key = 'm',
      mods = 'CMD',
      action = wezterm.action.DisableDefaultAssignment,
    },
    {
      key = 't',
      mods = 'CMD',
      action = wezterm.action.DisableDefaultAssignment,
    },
  }
end

return M
