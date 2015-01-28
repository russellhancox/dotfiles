function reload_config(files)
  hs.reload()
  hs.alert.show("Config reloaded")
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()
