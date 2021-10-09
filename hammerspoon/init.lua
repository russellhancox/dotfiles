mash = {"cmd", "alt", "ctrl"}

-- Hammerspoon basics
local function reload_config(files, flagTables)
  configWatcher:stop() -- prevent duplicate calls
  hs.alert.show("Config reloaded")
  hs.reload()
end
configWatcher = hs.pathwatcher.new(hs.configdir, reload_config):start()

-- Caffeinate
caf = hs.loadSpoon('Caffeine')
caf:bindHotkeys({toggle={mash, "c"}})
caf:start()

-- Shush
mm = hs.loadSpoon('MicMute')
mm:bindHotkeys({toggle={{}, 'f1'}}, 0.75)

-- Window movement config
require 'windows'

hs.hotkey.bind(mash, 'y', hs.toggleConsole)
hs.hotkey.bind(mash, "h", hs.hints.windowHints)
hs.hotkey.bind(mash, 'n', function() os.execute("open ~") end)
hs.hotkey.bind(mash, "l", function() hs.application.launchOrFocus("ScreenSaverEngine.app") end)

