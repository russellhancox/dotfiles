mash = {"cmd", "alt", "ctrl"}

-- Caffeinate
caf = hs.loadSpoon('Caffeine')
caf:start()

-- Shush
mm = hs.loadSpoon('MicMute')
mm:bindHotkeys({toggle={{}, 'f1'}}, 0.5)

-- Window movement config
require 'windows'

-- Keys
recbind = hs.loadSpoon('RecursiveBinder')
require 'keys'
