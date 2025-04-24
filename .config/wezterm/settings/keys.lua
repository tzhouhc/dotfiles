local wezterm = require("wezterm")

local M = {}

local home = os.getenv("HOME")

function M.update_config(config)
  config.bypass_mouse_reporting_modifiers = "ALT"

  config.keys = {
    -- Turn off the default CMD-m Hide action
    {
      key = "m",
      mods = "CMD",
      action = wezterm.action.DisableDefaultAssignment,
    },
    {
      key = 't',
      mods = 'CMD',
      action = wezterm.action.Multiple({
        wezterm.action.SpawnTab("DefaultDomain"),
        wezterm.action.EmitEvent("modify-tabs"),
      }),
    },
    {
      key = 't',
      mods = 'CMD|SHIFT',
      action = wezterm.action.Multiple({
        wezterm.action.SpawnCommandInNewTab(
          { args = { home .. "/.dotfiles/bin/ssh_to" } }
        ),
        wezterm.action.EmitEvent("modify-tabs"),
      }),
    },
    {
      key = 'w',
      mods = 'CMD',
      action = wezterm.action.Multiple({
        wezterm.action({ CloseCurrentTab = { confirm = false } }),
        wezterm.action.EmitEvent("modify-tabs"),
      }),
    },
    {
      key = "q",
      mods = "CMD",
      action = wezterm.action({ CloseCurrentTab = { confirm = false } }),
    },
    {
      key = "Enter",
      mods = "SHIFT",
      action = wezterm.action { SendString = "\x1b[13;2u" },
    },
    {
      key = "Enter",
      mods = "CTRL",
      action = wezterm.action { SendString = "\x1b[13;5u" },
    },
    {
      key = "p",
      mods = "CMD|SHIFT",
      action = wezterm.action.ActivateCommandPalette,
    },
    {
      key = "UpArrow",
      mods = "CMD|SHIFT",
      action = wezterm.action.EmitEvent("increase-window-opacity"),
    },
    {
      key = "DownArrow",
      mods = "CMD|SHIFT",
      action = wezterm.action.EmitEvent("decrease-window-opacity"),
    },
  }
end

return M
