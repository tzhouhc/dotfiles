local wezterm = require 'wezterm'

wezterm.on('decrease-window-opacity', function(window, _)
  local cfg = window:get_config_overrides()
  local opc = cfg.window_background_opacity
  if not opc then opc = 1 end
  opc = opc - 0.05
  if opc < 0 then
    opc = 0
  end
  window:set_config_overrides({ window_background_opacity = opc })
end)

wezterm.on('increase-window-opacity', function(window, _)
  local cfg = window:get_config_overrides()
  local opc = cfg.window_background_opacity
  if not opc then opc = 1 end
  opc = opc + 0.05
  if opc > 1 then
    opc = 1
  end
  window:set_config_overrides({ window_background_opacity = opc })
end)

-- check number of tabs, then modify window paddnig accordingly
-- (this is for avoiding the macos on-screen 'notch')
wezterm.on('modify-tabs', function(window, _)
  if #window:mux_window():tabs() > 1 then
    local cfg = {
      left = "0.3cell",
      right = "0cell",
      top = "0cell",
      bottom = "0cell",
    }
    window:set_config_overrides({ window_padding = cfg })
  else
    local cfg = {
      left = "0.3cell",
      right = "0cell",
      top = "1cell",
      bottom = "0cell",
    }
    window:set_config_overrides({ window_padding = cfg })
  end
end)
