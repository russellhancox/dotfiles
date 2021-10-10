require('hs.ipc')

mash = {"cmd", "alt", "ctrl"}

-- Shush
shush = hs.loadSpoon('Shush')
shush:start()

-- Caffeinate
caf = hs.loadSpoon('Caffeine')
caf:start()

-- Window movement config
require 'windows'

-- Keys
recbind = hs.loadSpoon('RecursiveBinder')
require 'keys'

-- Pop Pop!
fadelogo = hs.loadSpoon('FadeLogo')
require 'noises'
