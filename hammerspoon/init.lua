require('hs.ipc')

mash = {"cmd", "alt", "ctrl"}

-- Caffeinate
caf = hs.loadSpoon('Caffeine')
caf:start()

-- Window movement config
require 'windows'

-- Keys
recbind = hs.loadSpoon('RecursiveBinder')
require 'keys'

-- MicMute
micmute = hs.loadSpoon('MicMute')
micmute:bindHotkeys({toggle={'', 'F19'}}, 0.1)
