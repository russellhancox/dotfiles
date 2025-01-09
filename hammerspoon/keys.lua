local function appLaunchFn(name)
  f = function()
    hs.application.launchOrFocus(name)
  end
  return f
end

-- Helper to change the default audio output device and then
-- show a notification if successful.
local function switchOutputDevice(name)
  local dev = hs.audiodevice.findOutputByName(name)
  if dev then
    success = dev:setDefaultOutputDevice()
    if success then
      local notif = hs.notify.new(nil, {
        title='Changed output audio device',
        subTitle=name,
        autoWithdraw=true,
      })
      notif:send()
    end
  end
end

-- Change the RecursiveBind styling to use Avenir Next Condensed and appear in the
-- middle of the screen instead of the bottom edge.
recbind.helperFormat.textFont = 'Avenir Next Condensed'
recbind.helperEntryLengthInChar = 25
recbind.helperFormat.atScreenEdge = 0

local singleKey = recbind.singleKey

-- Returns another bound menu for each output audio device, allowing to switch
-- device with a menu key.
local function outputDeviceTable()
  keyArray = {}
  for i, dev in ipairs(hs.audiodevice.allOutputDevices()) do
    keyArray[singleKey(tostring(i), dev:name())] = function() switchOutputDevice(dev:name()) end
  end
  return recbind.recursiveBind(keyArray)
end

hs.hotkey.bind({}, 'F10', recbind.recursiveBind({
  [singleKey('space', 'hints')] = hs.hints.windowHints,
  [singleKey('w', 'win')] = function() windowHotkey:enter() end,
  [singleKey('c', 'caf')] = function() caf:clicked() end,
  [singleKey('l', 'lock')] = appLaunchFn('ScreenSaverEngine.app'),
  [singleKey('s', 'sound+')] = {
      [singleKey('p', 'Play/Pause')] = hs.spotify.playpause,
      [singleKey('n', 'Next')] = hs.spotify.next,
      [singleKey('b', 'Back')] = hs.spotify.previous,
      [singleKey('s', 'Switch output')] = outputDeviceTable(),
      [singleKey('d', 'Display')] = function()
          local artist = hs.spotify.getCurrentArtist()
          local track = hs.spotify.getCurrentTrack()
          local album = hs.spotify.getCurrentAlbum()
          local trackId = string.match(hs.spotify.getCurrentTrackId(), "([^:]+)$")

          local title = artist..' - '..track
          local subTitle = album
          local url = 'https://open.spotify.com/oembed?url=https%3A%2F%2Fopen.spotify.com%2Ftrack%2F'..trackId

          hs.http.asyncGet(url, nil, function(status, body, headers)
            local jsonData = hs.json.decode(body)
            local albumArt = hs.image.imageFromURL(jsonData.thumbnail_url)
            local notif = hs.notify.new(nil, {
              title=title,
              subTitle='Album: '..subTitle,
              autoWithdraw=true,
              contentImage=albumArt,
            })
            notif:send()
          end)
      end
  },
  [singleKey('h', 'hammerspoon+')] = {
      [singleKey('c', 'Console')] = hs.openConsole,
      [singleKey('r', 'Reload config')] = hs.reload,
  },
}))

