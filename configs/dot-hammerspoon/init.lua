-- window management; replaces Rectangle.app
require('windows')
require('apps')

-- required for cli use
require("hs.ipc")

-- reload shortcut
local function reload_config(files)
    local do_reload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            do_reload = true
        end
    end
    if do_reload then
        hs.reload()
    end
end

MyWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()
hs.alert.show("Hammerspoon config reloaded.")
