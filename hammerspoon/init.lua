local mash = {"cmd", "alt", "ctrl"}

require 'reload'
require 'windows'

hs.hotkey.bind(mash, "H", function()
  hs.hints.windowHints()
end)

hs.hotkey.bind(mash, "L", function()
  hs.application.launchOrFocus("ScreenSaverEngine.app")
end)
