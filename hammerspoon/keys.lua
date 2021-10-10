local function openWithFinder(path)
  os.execute('open '..path)
  hs.application.launchOrFocus('Finder')
end
local function appLaunchFn(name)
  f = function()
    hs.application.launchOrFocus(name)
  end
  return f
end

local singleKey = recbind.singleKey

-- Change the RecursiveBind styling to use Roboto Condensed and appear in the
-- middle of the screen instead of the bottom edge.
recbind.helperFormat.textFont = 'Roboto Condensed'
recbind.helperFormat.atScreenEdge = 0

recursiveMenu = recbind.recursiveBind({
  [singleKey('space', 'hints')] = hs.hints.windowHints,
  [singleKey('c', 'caf')] = function() caf:clicked() end,
  [singleKey('l', 'lock')] = appLaunchFn('ScreenSaverEngine.app'),
  [singleKey('f', 'file+')] = {
     [singleKey('h', 'Home')] = function() openWithFinder('~') end,
     [singleKey('d', 'Download')] = function() openWithFinder('~/Downloads') end,
  },
  [singleKey('a', 'app+')] = {
     [singleKey('a', 'ActMon')] = appLaunchFn('Activity Monitor'),
     [singleKey('c', 'Chrome')] = appLaunchFn('Google Chrome'),
     [singleKey('r', 'CodeRunner')] = appLaunchFn('CodeRunner'),
     [singleKey('n', 'Console')] = appLaunchFn('Console'),
     [singleKey('g', 'GoPro')] = appLaunchFn('GoPro Webcam'),
     [singleKey('t', 'iTerm')] = appLaunchFn('iTerm'),
  },
  [singleKey('h', 'hammerspoon+')] = {
     [singleKey('c', 'Console')] = function() hs.openConsole() end,
     [singleKey('r', 'Reload config')] = hs.reload,
  }
})

hs.hotkey.bind({}, 'F10', recursiveMenu)
hs.hotkey.bind({}, 'F15', recursiveMenu)
