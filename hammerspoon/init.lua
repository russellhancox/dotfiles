mash = {"cmd", "alt", "ctrl"}

require 'reload'

require 'caffeine'
require 'mouse'
require 'store'
require 'windows'

hs.hotkey.bind(mash, 'y', hs.toggleConsole)
hs.hotkey.bind(mash, "h", hs.hints.windowHints)
hs.hotkey.bind(mash, 'n', function() os.execute("open ~") end)
hs.hotkey.bind(mash, "l", function() hs.application.launchOrFocus("ScreenSaverEngine.app") end)
