-- Set grid to 50x50 with no margin.
hs.grid.setGrid('50x50')
hs.grid.setMargins({0, 0})
local frameCache = {}

-- Helper to locate the current window and only return if it's visible
local function curWin()
  local win = hs.window.focusedWindow()
  if win and win:isVisible() then
    return win
  end
end
local function modifyWin(fn)
  local f = function()
    local win = curWin()
    if not win then return end
    fn(win)
    frameCache[win:id()] = nil
  end
  return f
end

-- Helper to prevent keypresses being passed to applications while the modal
-- is active. Cribbed from https://github.com/asmagill/hammerspoon-config/blob/master/_scratch/modalSuppression.lua.
-- and extended to allow multiple flag combinations for a single keycode.
local function suppressOtherKeys(modal)
  local passThroughKeys = {}
  for i,v in ipairs(modal.keys) do
    -- parse for flags, get keycode for each
    local kc, mods = tostring(v._hk):match("keycode: (%d+), mods: (0x[^ ]+)")
    local hkFlags = tonumber(mods)
    print('kc: ' .. kc .. ', khFlags: ' .. hkFlags)
    local hkOriginal = hkFlags
    local flags = 0
    if (hkFlags &  256) ==  256 then hkFlags, flags = hkFlags -  256, flags | hs.eventtap.event.rawFlagMasks.command   end
    if (hkFlags &  512) ==  512 then hkFlags, flags = hkFlags -  512, flags | hs.eventtap.event.rawFlagMasks.shift     end
    if (hkFlags & 2048) == 2048 then hkFlags, flags = hkFlags - 2048, flags | hs.eventtap.event.rawFlagMasks.alternate end
    if (hkFlags & 4096) == 4096 then hkFlags, flags = hkFlags - 4096, flags | hs.eventtap.event.rawFlagMasks.control   end
    if hkFlags ~= 0 then print("unexpected flag pattern detected for " .. tostring(v._hk)) end
    if not passThroughKeys[tonumber(kc)] then
      passThroughKeys[tonumber(kc)] = {}
    end
    passThroughKeys[tonumber(kc)][flags] = true
  end
  return hs.eventtap.new({
    hs.eventtap.event.types.keyDown,
    hs.eventtap.event.types.keyUp,
  }, function(event)
    -- check only the flags we care about and filter the rest
    local flags = event:getRawEventData().CGEventData.flags  & (
      hs.eventtap.event.rawFlagMasks.command   |
      hs.eventtap.event.rawFlagMasks.control   |
      hs.eventtap.event.rawFlagMasks.alternate |
      hs.eventtap.event.rawFlagMasks.shift
    )
    local allowedFlags = passThroughKeys[event:getKeyCode()]
    if allowedFlags == nil then
      return true -- delete it, it's a key we want suppressed
    elseif allowedFlags[flags] then
      return false -- pass it through so hotkey can catch it
    else
      return true -- delete it if we got this far -- it's a key that we want suppressed
    end
  end)
end

-- Add W-Mode, assign to mash+space, create menubar item when
-- entering and delete it when exiting.
local windowHotkey = hs.hotkey.modal.new(mash, 'space')
function windowHotkey:entered()
  menubar = hs.menubar.new()
  menubar:setTitle('W-Mode')
  _eventTap = suppressOtherKeys(self):start()
end
function windowHotkey:exited()
  _eventTap:stop()
  _eventTap = nil
  menubar:delete()
end

-- Exit W-Mode
windowHotkey:bind({}, 'escape', function() windowHotkey:exit() end)
windowHotkey:bind(mash, 'space', function() windowHotkey:exit() end)

-- Toggle a window between its normal size, and being maximized.
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

-- Move current window to next/previous screen
windowHotkey:bind({}, 'n', modifyWin(function(win)
  win:moveToScreen(win:screen():next())
end))
windowHotkey:bind({}, 'p', modifyWin(function(win)
  win:moveToScreen(win:screen():previous())
end))

-- Helper to bind a key in W-Mode to a grid setting
local function makeWindowHotkey(hotKey, gridTable)
  windowHotkey:bind({}, hotKey, modifyWin(function(win)
    hs.grid.set(win, gridTable, win:screen())
  end))
end

-- Move current window around
makeWindowHotkey('q', {x=0,  y=0,  w=25, h=50}) -- Left half
makeWindowHotkey('r', {x=25, y=0,  w=25, h=50}) -- Right half
makeWindowHotkey('0', {x=0,  y=0,  w=29, h=50}) -- Side-by-side 100 col diff
makeWindowHotkey('4', {x=29, y=0,  w=21, h=50}) -- Right side 40%

makeWindowHotkey('y', {x=25,  y=30, w=25, h=20}) -- Bottom right corner
makeWindowHotkey('u', {x=25,  y=0, w=25, h=35}) -- Upper right corner

