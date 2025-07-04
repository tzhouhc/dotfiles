local wezterm = require 'wezterm'

local function is_osx()
	local f = io.popen("uname -a")
	return (f:read("*a") or ""):match("Darwin") == "Darwin"
end

wezterm.on('decrease-window-opacity', function(window, _)
  local cfg = window:get_config_overrides() or { window_background_opacity = 1 }
  local opc = cfg.window_background_opacity
  if not opc then opc = 1 end
  opc = opc - 0.05
  if opc < 0 then
    opc = 0
  end
  window:set_config_overrides({ window_background_opacity = opc })
end)

wezterm.on('increase-window-opacity', function(window, _)
  local cfg = window:get_config_overrides() or { window_background_opacity = 1 }
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
  if not is_osx() then
    return
  end
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
