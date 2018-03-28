-- Set grid to 50x50 with no margin.
hs.grid.setGrid('50x50')
hs.grid.setMargins({0, 0})

-- Helper to locate the current window and only return it it's visible
local function curWin()
  local win = hs.window.focusedWindow()
  if win and win:isVisible() then
    return win
  end
end

-- Add W-Mode, assign to mash+space, create menubar item when
-- entering and delete it when exiting.
local windowHotkey = hs.hotkey.modal.new(mash, 'space')
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

-- Toggle a window between its normal size, and being maximized.
local frameCache = {}
windowHotkey:bind({}, 'f', function()
  local win = curWin()
  if not win then return end
  if frameCache[win:id()] then
    win:setFrame(frameCache[win:id()])
    frameCache[win:id()] = nil
  else
      frameCache[win:id()] = win:frame()
      win:maximize()
  end
end)

-- Show grid
windowHotkey:bind({}, 'g', function()
  windowHotkey:exit()
  hs.grid.show()
end)

-- Helper to bind a key in W-Mode to a grid setting
local function makeWindowHotkey(hotKey, gridTable)
  windowHotkey:bind({}, hotKey, function()
    local win = curWin()
    if not win then return end
    hs.grid.set(win, gridTable, win:screen())
    frameCache[win:id()] = nil
  end)
end

-- Move current window around
makeWindowHotkey('l', {x=0,  y=0,  w=25, h=50}) -- Left half
makeWindowHotkey('r', {x=25, y=0,  w=25, h=50}) -- Right half
makeWindowHotkey('0', {x=0,  y=0,  w=29, h=47}) -- Side-by-side 100 col diff
makeWindowHotkey('4', {x=30, y=0,  w=40, h=50}) -- Right 40% width
makeWindowHotkey('6', {x=0,  y=0,  w=60, h=50}) -- Left 60% width
makeWindowHotkey('e', {x=0,  y=25, w=25, h=25}) -- Bottom left corner
makeWindowHotkey('k', {x=0,  y=0,  w=25, h=47}) -- Left 95% height
