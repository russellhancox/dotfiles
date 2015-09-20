local caffeine = hs.menubar.new()

function setCaffeineDisplay(state)
    local result
    if state then
        result = caffeine:setIcon("caffeine-on.pdf")
    else
        result = caffeine:setIcon("caffeine-off.pdf")
    end
end

function caffeineClicked(button)
  if button['shift'] then
    hs.openConsole(true)
  elseif button['cmd'] then
    hs.openPreferences()
  else
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
  end
end

caffeine:setClickCallback(caffeineClicked)
setCaffeineDisplay(hs.caffeinate.get("displayIdle"))

hs.hotkey.bind(mash, 'c', caffeineClicked)
