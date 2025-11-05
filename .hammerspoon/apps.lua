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

local function hidden_wez_window(wez)
	for _, win in ipairs(wez:allWindows()) do
		if not win:isVisible() then
			return win
		end
	end
	return nil
end

---use <cmd> + <tilde> to summon WezTerm or despawn.
function M.toggle_wizterm()
	local wez = hs.application.find("Wezterm")
	if not wez or wez == nil then
		hs.application.launchOrFocus("WezTerm")
		return
	end
	-- always hide wez app: hidden apps are considered across spaces.
	if wez:isFrontmost() then
		-- extracting this `hide` to before the loop sometimes would cause
		-- flickering of the window. I can only assume that the `isFrontmost`
		-- call actually has some time-related side effect.
		wez:hide()
	else
		wez:hide()
		-- we want to bring forth wezterm. Either it's on current space and hidden,
		-- or its hidden on another space, which makes it visible in `allWindows`.
		-- Regardless, we want to move it to current space and then activate it.
		local space = hs.spaces.activeSpaceOnScreen()
		local hidden_wez = hidden_wez_window(wez)
		if hidden_wez ~= nil then
			hs.spaces.moveWindowToSpace(hidden_wez, space)
		end
		wez:activate()
	end
end

local function unhidden_wez_app()
	local windows = { hs.application.find("WezTerm") }
	for _, win in ipairs(windows) do
		if not win:isHidden() and not win:isFrontmost() then
			return win
		end
	end
	return nil
end

local function unhidden_wez_app_present()
	return unhidden_wez_app() ~= nil
end

local function focus_unhidden_wez_window()
	local win = unhidden_wez_app()
	win:activate()
end

-- invoke "seb" with <cmd> + <opt> + <a>.
function M.summon_quick_open()
	-- pipe to null and send to background to prevent blocking hs
	os.execute(
		"/Applications/WezTerm.app/Contents/MacOS/wezterm --config-file $HOME/.config/wezterm/popup_wezterm.lua start -- $HOME/.dotfiles/sbin/gadget >& /dev/null &"
	)
	hs.timer.waitUntil(unhidden_wez_app_present, focus_unhidden_wez_window, 0.1)
end

function M.summon_quick_chat()
	-- pipe to null and send to background to prevent blocking hs
	os.execute(
		"/Applications/WezTerm.app/Contents/MacOS/wezterm --config-file $HOME/.config/wezterm/app_wezterm.lua start -- $HOME/.dotfiles/sbin/chat_wrapper >& /dev/null &"
	)
	hs.timer.waitUntil(unhidden_wez_app_present, focus_unhidden_wez_window, 0.1)
end

return M
