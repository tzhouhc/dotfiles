local wezterm = require 'wezterm'

wezterm.on('decrease-window-opacity', function(window, pane)
  local cfg = window:get_config_overrides() or { window_background_opacity = 1 }
  local opc = cfg.window_background_opacity
  opc = opc - 0.05
  if opc < 0 then
    opc = 0
  end
  window:set_config_overrides({window_background_opacity = opc})
end)

wezterm.on('increase-window-opacity', function(window, pane)
  local cfg = window:get_config_overrides() or { window_background_opacity = 1 }
  local opc = cfg.window_background_opacity
  opc = opc + 0.05
  if opc > 1 then
    opc = 1
  end
  window:set_config_overrides({window_background_opacity = opc})
end)
