-- rcmd emulates https://lowtechguys.com/rcmd/, albeit poorly.

hs.eventtap.new({
  hs.eventtap.event.types.keyDown,
  hs.eventtap.event.types.keyUp,
}, function(event)
  local evt = event:getRawEventData().NSEventData

  -- check that rcmd is held
  local combo = (
    hs.eventtap.event.rawFlagMasks.deviceRightCommand |
    hs.eventtap.event.rawFlagMasks.control   |
    hs.eventtap.event.rawFlagMasks.alternate |
    hs.eventtap.event.rawFlagMasks.shift
  )

  if (evt.modifierFlags & combo) ~= combo then
    return false
  end
  if event:getType() ~= hs.eventtap.event.types.keyUp then
    return false
  end


  local wantFirstChar = event:getCharacters(true):lower()

  for _, app in ipairs(hs.application.runningApplications()) do
    if app:kind() > 0 and not app:isFrontmost() then
      local title = app:title()
      for word in title:gmatch("(%w+) *") do
        if word:sub(1, 1):lower() == wantFirstChar then
          app:activate()
          return true
        end
      end
    end
  end

  return true
end):start()
