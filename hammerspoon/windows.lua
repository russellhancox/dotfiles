local mash = {"cmd", "alt", "ctrl"}

local grid = require 'hs.grid'
grid.GRIDHEIGHT = 100
grid.GRIDWIDTH = 100
grid.MARGINX = 0
grid.MARGINY = 0

windowHotkey = hs.hotkey.modal.new(mash, "space")
function windowHotkey:entered()
  menubar = hs.menubar.new()
  menubar:setTitle('W-Mode')
end
function windowHotkey:exited()
  menubar:delete()
end

windowHotkey:bind({}, 'escape', function() windowHotkey:exit() end)
windowHotkey:bind({}, 'f', function() hs.window.focusedWindow():maximize() end)
windowHotkey:bind({}, 'n', function()
  local win = hs.window.focusedWindow()
  win:moveToScreen(win:screen():next())
end)

windowHotkey:bind({}, 'l', function()
  local win = hs.window.focusedWindow()
  hs.grid.set(win, {x=0, y=0, w=50, h=100}, win:screen())
end)

windowHotkey:bind({}, 'r', function()
  local win = hs.window.focusedWindow()
  hs.grid.set(win, {x=50, y=0, w=50, h=100}, win:screen())
end)

