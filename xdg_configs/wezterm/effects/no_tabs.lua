local wezterm = require("wezterm")

local M = {}

function M.update_config(config)
  config.keys = {
    -- Turn off the default CMD-t tab
    {
      key = "t",
      mods = "CMD",
      action = wezterm.action.DisableDefaultAssignment,
    },
  }
end

return M
