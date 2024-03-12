local function appLaunchFn(name)
  f = function()
    hs.application.launchOrFocus(name)
  end
  return f
end

local singleKey = recbind.singleKey

-- Change the RecursiveBind styling to use Roboto Condensed and appear in the
-- middle of the screen instead of the bottom edge.
recbind.helperFormat.textFont = 'Roboto Condensed'
recbind.helperFormat.atScreenEdge = 0

recursiveMenu = recbind.recursiveBind({
  [singleKey('space', 'hints')] = hs.hints.windowHints,
  [singleKey('w', 'win')] = function() windowHotkey:enter() end,
  [singleKey('c', 'caf')] = function() caf:clicked() end,
  [singleKey('l', 'lock')] = appLaunchFn('ScreenSaverEngine.app'),
  [singleKey('s', 'spotify+')] = {
      [singleKey('p', 'Play/Pause')] = hs.spotify.playpause,
      [singleKey('n', 'Next')] = hs.spotify.next,
      [singleKey('b', 'Back')] = hs.spotify.previous,
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
})

hs.hotkey.bind({}, 'F10', recursiveMenu)
hs.hotkey.bind({}, 'F15', recursiveMenu)
hs.hotkey.bind({}, 'F16', hs.hints.windowHints)
