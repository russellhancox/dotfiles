--- === Shush ===
---
--- Implements push-to-talk and push-to-mute functionality with `fn` and F1 keys.
--- Heavily inspired by the PushToTalk spoon and modified to remove the app
--- watching code (which I don't use), to allow the use of both F1 and Fn as
--- hotkeys (for portability between built-in and external keyboards), to
--- allow mode-changing by double-tapping the hotkey, adding an alert sound
--- when mute state changes and removing 2 of the modes.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Shush"
obj.version = "0.1"
obj.author = "Russell Hancox"
obj.homepage = "https://github.com/russellhancox/dotfiles/tree/main/hammerspoon/Spoons/Shush.spoon"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.modes = {
  ptt=1,
  rtt=2,
}
obj.defaultMode = obj.modes.ptt


--- Updates the state based on the mode and state of hotkeys. When the state
--- changes the menu item's icon will change and a sound is played.
function obj:updateState()
  local device = hs.audiodevice.defaultInputDevice()
  if device:muted() == nil then
    return
  end
  local muted = false
  if obj.mode == obj.modes.ptt then
    if obj.pushed then
      obj.menubar:setIcon(hs.spoons.resourcePath("record.pdf"), false)
    else
      obj.menubar:setIcon(hs.spoons.resourcePath("unrecord.pdf"))
      muted = true
    end
  elseif obj.mode == obj.modes.rtt then
    if obj.pushed then
      obj.menubar:setIcon(hs.spoons.resourcePath("unrecord.pdf"))
      muted = true
    else
      obj.menubar:setIcon(hs.spoons.resourcePath("record.pdf"), false)
    end
  end
  device:setMuted(muted)
  obj.alert_sound:stop()
  obj.alert_sound:play()
end

--- Switches to the selected mode, including updating the menu to show which
--- mode is currently active.
function obj:setMode(mode)
  obj.mode = mode

  menutable = {
    { title = "Push-to-talk", fn = function() obj:setMode(obj.modes.ptt) end },
    { title = "Release-to-talk", fn = function() obj:setMode(obj.modes.rtt) end },
  }

  if mode == obj.modes.ptt then
    menutable[1].title = '✓ ' .. menutable[1].title
  elseif mode == obj.modes.rtt then
    menutable[2].title = '✓ ' .. menutable[2].title
  end

  obj.menubar:setMenu(menutable)
  obj:updateState()
end

--- Toggles between Push-to-Talk and Release-to-Talk modes.
function obj:toggleMode()
  if obj.mode == obj.modes.ptt then
    obj:setMode(obj.modes.rtt)
  elseif obj.mode == obj.modes.rtt then
    obj:setMode(obj.modes.ptt)
  end
end

--- Callback triggered when either F1 or Fn are pressed.
--- If this function is called within 0.5s of the last time it was pressed
--- the mode is toggled.
local function keydownCallback()
  if hs.timer.secondsSinceEpoch() < obj.lastPushTime + 0.5 then
    -- tapped key twice, toggle mode
    obj:toggleMode()
  else
    obj.lastPushTime = hs.timer.secondsSinceEpoch()
  end
  obj.pushed = true
  obj:updateState()
end

--- Callback triggered when either F1 or Fn are released.
local function keyupCallback()
  obj.pushed = false
  obj:updateState()
end

--- Callback function for the eventtap, calls keyupCallback and keydownCallback
--- when Fn is pressed/released.
local function eventTapWatcher(event)
  if event:getFlags()['fn'] then
    keydownCallback()
  elseif event:getKeyCode() == 63 then
    keyupCallback()
  end
end

-- Callback called each time input devices change
local function inputDeviceWatcherCallback(arg)
  if hs.audiodevice.defaultInputDevice():muted() == nil then
    obj.menubar:removeFromMenuBar()
  else
    obj.menubar:returnToMenuBar()
    obj:updateState()
  end
end

--- Shush:init()
function obj:init()
end

--- Shush:start()
--- Method
--- Starts menu and key watchers
function obj:start()
  self:stop()

  obj.lastPushTime = 0
  obj.pushed = false
  obj.alert_sound = hs.sound.getByName('Pop')

  obj.eventTapWatcher = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, eventTapWatcher)
  obj.eventTapWatcher:start()
  print('Enabled hotkey Fn')
  obj.hotkey = hs.hotkey.bind({}, 'f1', keydownCallback, keyupCallback)

  obj.menubar = hs.menubar.new()
  obj:setMode(obj.defaultMode)

  hs.audiodevice.watcher.setCallback(function()
    inputDeviceWatcherCallback()
  end)
  inputDeviceWatcherCallback()
  hs.audiodevice.watcher.start()
end

--- Shush:stop()
--- Method
--- Stops Shush
function obj:stop()
  if obj.eventTapWatcher then
    obj.eventTapWatcher:stop()
    print('Disabled hotkey Fn')
    obj.eventTapWatcher = nil
  end
  if obj.hotkey then
    obj.hotkey:delete()
    obj.hotkey = nil
  end
  if obj.menubar then
    obj.menubar:delete()
    obj.menubar = nil
  end
end

return obj
