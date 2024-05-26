local logger = hs.logger.new('apps', 'debug')

-- use <cmd> + <tilde> to summon WezTerm or despawn.
hs.hotkey.bind({ "cmd" }, "`", function()
  local wez = hs.application.find("Wezterm")
  if not wez or wez == nil then
    hs.application.launchOrFocus("WezTerm")
    return
  end
  if wez:isFrontmost() then
    wez:hide()
  else
    wez:activate()
  end
end)

local function unhidden_wez_window()
  local windows = { hs.application.find("WezTerm") }
  for _, win in ipairs(windows) do
    if not win:isHidden() and not win:isFrontmost() then
      return win
    end
  end
  return nil
end

local function unhidden_wez_window_present()
  return unhidden_wez_window() ~= nil
end

local function focus_unhidden_wez_window()
  local win = unhidden_wez_window()
  win:activate()
end

-- invoke "seb" with <cmd> + <opt> + <a>.
hs.hotkey.bind({ "cmd", "ctrl" }, "a", function()
  -- pipe to null and send to background to prevent blocking hs
  os.execute(
    "/Applications/WezTerm.app/Contents/MacOS/wezterm --config-file $HOME/.config/wezterm/popup_wezterm.lua start -- $HOME/.dotfiles/bin/seb >& /dev/null &")
  -- allow app some startup time that's barely noticeable
  local retries = 0
  -- do not spend more than 1s on trying this
  logger.f("entering")

  hs.timer.waitUntil(
    unhidden_wez_window_present,
    focus_unhidden_wez_window,
    0.1
  )
end)
