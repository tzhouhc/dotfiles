local wezterm = require 'wezterm'
local act = wezterm.action

local config = wezterm.config_builder()

wezterm.on('augment-command-palette', function(window, pane)
  return {
    {
      brief = 'Decrease Opacity',
      icon = 'md_mirror_rectangle',
      action = act.EmitEvent("decrease-window-opacity"),
    },
    {
      brief = 'Increase Opacity',
      icon = 'md_mirror_rectangle',
      action = act.EmitEvent("increase-window-opacity"),
    },
  }
end)

return config
