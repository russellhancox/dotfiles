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

singleKey = recbind.singleKey

hs.hotkey.bind({}, 'F15', recbind.recursiveBind({
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
     [singleKey('c', 'Console')] = function() hs.console.hswindow():focus() end,
     [singleKey('r', 'Reload config')] = hs.reload,
  }
}))
