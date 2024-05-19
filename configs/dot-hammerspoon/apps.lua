local logger = hs.logger.new('apps', 'debug')

-- use <cmd> + <tilde> to summon WezTerm or despawn.
hs.hotkey.bind({ "cmd" }, "`", function()
  wez = hs.application.find("Wezterm")
  if not wez then
    hs.application.launchOrFocus("WezTerm")
  end
  if wez:isFrontmost() then
    wez:hide()
  else
    wez:activate()
  end
end)

-- invoke "seb" with <cmd> + <opt> + <a>.
hs.hotkey.bind({ "cmd", "ctrl" }, "a", function()
  os.execute("$HOME/.dotfiles/bin/hide_iterm_window")
  os.execute(
    "/Applications/WezTerm.app/Contents/MacOS/wezterm --config-file $HOME/.config/wezterm/popup_wezterm.lua start -- $HOME/.dotfiles/bin/seb >& /dev/null")
  -- TODO:
  -- this doesn't yet focus the app properly.
  -- thought: get all open wezterm windows
end)
