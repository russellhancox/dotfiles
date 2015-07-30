local wifiWatcher = hs.wifi.watcher.new(function()
  newSSID = hs.wifi.currentNetwork()
  if newSSID then
    hs.notify.new({
        title='WiFi',
        informativeText='Connected to '..newSSID
    }):send():release()
  end
end)
wifiWatcher:start()
