-- import mappings
require("mappings")
-- required for cli use
require("hs.ipc")

local notify = require("hs.notify")

-- reload shortcut
local function reload_config(files)
	local do_reload = false
	for _, file in pairs(files) do
		if file:sub(-4) == ".lua" then
			do_reload = true
		end
	end
	if do_reload then
		hs.reload()
	end
end

MyWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()
notify.show("Hammerspoon", "", "Config reloaded.")
