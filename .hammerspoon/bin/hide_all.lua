#!/usr/bin/env hs_runner

local wins = require"hs.window"
local windows = wins:allWindows()
for _, win in ipairs(windows) do
  win:application():hide()
end
