local wezterm = require 'wezterm'

local M = {}

function M.update_config(config)
  config.bypass_mouse_reporting_modifiers = 'ALT'
end

return M
