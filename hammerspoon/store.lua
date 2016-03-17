local stored_string = ''

hs.hotkey.bind(mash, 'escape', function()
  hs.eventtap.keyStrokes(stored_string)
end)

hs.hotkey.bind(mash, 'f1', function()
  previous_window = hs.window.frontmostWindow()

  success, text = hs.applescript.applescript([[
    set dialog to (display dialog "Enter text:" ¬
    default answer "" ¬
    hidden answer true ¬
    buttons {"OK", "Cancel"} ¬
    default button 1)
    return text returned of dialog
  ]])
  if success then
    stored_string = text
  end

  previous_window:focus()
end)
