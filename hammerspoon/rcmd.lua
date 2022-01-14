-- rcmd emulates https://lowtechguys.com/rcmd/, albeit poorly.

hs.eventtap.new({
  hs.eventtap.event.types.keyDown,
  hs.eventtap.event.types.keyUp,
}, function(event)
  local evt = event:getRawEventData().NSEventData

  -- check that rcmd is held
  local flags = evt.modifierFlags & (
    hs.eventtap.event.rawFlagMasks.deviceRightCommand |
    hs.eventtap.event.rawFlagMasks.control   |
    hs.eventtap.event.rawFlagMasks.alternate |
    hs.eventtap.event.rawFlagMasks.shift
  )

  if flags ~= hs.eventtap.event.rawFlagMasks.deviceRightCommand then
    return false
  end
  if event:getType() ~= hs.eventtap.event.types.keyDown then
    return false
  end

  local firstChar = event:getCharacters(true)

  for _, app in ipairs(hs.application.runningApplications()) do
    if app:kind() > 0 and not app:isFrontmost() then
      local firstChar = app:title():sub(1, 1):lower()
      if firstChar == event:getCharacters(true) then
        app:activate()
        return true
      end
    end
  end

  return true
end):start()
