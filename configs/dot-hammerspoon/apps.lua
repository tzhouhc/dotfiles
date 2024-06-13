local M = {}

local default_exclude = {
  Wezterm = true,
}

---find the first running app window that is not in excluded and is somewhat
---normal, then focus it
---@param excluded table
local function pop_app_stack(excluded)
  local wins = hs.window.allWindows()
  for _, win in ipairs(wins) do
    local app = win:application()
    if app == nil then
      goto continue
    end
    local name = app:name()
    if not excluded[name] and win:isStandard() then
      win:focus()
      return
    end
    ::continue::
  end
end

---use <cmd> + <tilde> to summon WezTerm or despawn.
function M.toggle_wizterm()
  local wez = hs.application.find("Wezterm")
  if not wez or wez == nil then
    hs.application.launchOrFocus("WezTerm")
    return
  end
  if wez:isFrontmost() then
    wez:hide()
    -- after hiding wezterm, avoid osx defaulting back to Finder as the focus
    -- since it's hecking useless.
    pop_app_stack(default_exclude)
  else
    wez:activate()
  end
end

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
function M.summon_quick_open()
  -- pipe to null and send to background to prevent blocking hs
  os.execute(
    "/Applications/WezTerm.app/Contents/MacOS/wezterm --config-file $HOME/.config/wezterm/popup_wezterm.lua start -- $HOME/.dotfiles/bin/seb >& /dev/null &")
  hs.timer.waitUntil(
    unhidden_wez_window_present,
    focus_unhidden_wez_window,
    0.1
  )
end

return M
