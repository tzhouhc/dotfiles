-- ues <cmd> + <tilde> to summon WezTerm or despawn.
hs.hotkey.bind({"cmd"}, "`", function()
  wez = hs.application.find("Wezterm")
  if wez then
    if wez:isFrontmost() then
      wez:hide()
    else
      wez:activate()
    end
  else
    hs.application.launchOrFocus("WezTerm")
  end
end)
