local wezterm = require 'wezterm'
local mux = wezterm.mux

-- start in maximized mode
wezterm.on('gui-startup', function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():toggle_fullscreen()
end)
