local mash = {"cmd", "alt", "ctrl"}

local grid = require 'hs.grid'
grid.GRIDHEIGHT = 100
grid.GRIDWIDTH = 100
grid.MARGINX = 0
grid.MARGINY = 0

-- Helper to locate the current window and only return it if it's visible
function curWin()
  local win = hs.window.focusedWindow()
   if win:isVisible() then
    return win
  end
end

-- Helper to bind a key in W-Mode to a grid setting
function makeWindowHotkey(hotKey, gridTable)
  windowHotkey:bind({}, hotKey, function()
    local win = curWin()
    if not win then return end
    hs.grid.set(win, gridTable, win:screen())
  end)
end

-- Add W-Mode, assign to mash+space, create menubar item when
-- entering and delete it when exiting.
windowHotkey = hs.hotkey.modal.new(mash, 'space')
function windowHotkey:entered()
  menubar = hs.menubar.new()
  menubar:setTitle('W-Mode')
end
function windowHotkey:exited()
  menubar:delete()
end

-- Exit W-Mode
windowHotkey:bind({}, 'escape', function() windowHotkey:exit() end)
windowHotkey:bind(mash, 'space', function() windowHotkey:exit() end)

-- Move current window to next/previous screen
windowHotkey:bind({}, 'n', function()
  local win = curWin()
  if not win then return end
  win:moveToScreen(win:screen():next())
end)
windowHotkey:bind({}, 'p', function()
  local win = curWin()
  if not win then return end
  win:moveToScreen(win:screen():previous())
end)

-- Move current window around
makeWindowHotkey('l', {x=0, y=0, w=50, h=100})  -- Left half
makeWindowHotkey('r', {x=50, y=0, w=50, h=100}) -- Right half
makeWindowHotkey('f', {x=0, y=0, w=100, h=100}) -- Maximize (*not* fullscreen)
makeWindowHotkey('0', {x=0, y=0, w=58, h=95})   -- Side-by-side 100 col diff
makeWindowHotkey('4', {x=60, y=0, w=40, h=100}) -- Right 40% width
makeWindowHotkey('6', {x=0, y=0, w=60, h=100})  -- Left 60% width
makeWindowHotkey('e', {x=0, y=50, w=50, h=50})  -- Bottom left corner
makeWindowHotkey('k', {x=0, y=0, w=50, h=95})   -- Left 95% height

