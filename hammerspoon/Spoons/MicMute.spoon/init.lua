--- === MicMute ===
---
--- Microphone Mute Toggle and status indicator
---
--- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/MicMute.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/MicMute.spoon.zip)

local obj={}
obj.__index = obj

-- Metadata
obj.name = "MicMute"
obj.version = "1.1"
obj.author = "dctucker <dctucker@github.com>"
obj.homepage = "https://dctucker.com"
obj.license = "MIT - https://opensource.org/licenses/MIT"

function obj:updateMicMute(muted)
	if muted == -1 then
		muted = hs.audiodevice.defaultInputDevice():muted()
	end
	if muted then
		obj.mute_menu:setTitle("🔇")
	else
		obj.mute_menu:setTitle("🎤")
	end
end

--- MicMute:toggleMicMute()
--- Method
--- Toggle mic mute on/off
---
--- Parameters:
---  * None
function obj:toggleMicMute()
	local mic = hs.audiodevice.defaultInputDevice()
	if mic:muted() then
		mic:setInputMuted(false)
	else
		mic:setInputMuted(true)
	end
	obj:updateMicMute(-1)
end

--- MicMute:bindHotkeys(mapping, latch_timeout)
--- Method
--- Binds hotkeys for MicMute
---
--- Parameters:
---  * mapping - A table containing hotkey modifier/key details for the following items:
---   * toggle - This will cause the microphone mute status to be toggled. Hold for momentary, press quickly for toggle.
---  * latch_timeout - Time in seconds to hold the hotkey before momentary mode takes over, in which the mute will be toggled again when hotkey is released. Latch if released before this time. 0.75 for 750 milliseconds is a good value.
function obj:bindHotkeys(mapping, latch_timeout)
	local mods = mapping["toggle"][1]
	local key = mapping["toggle"][2]

	if latch_timeout then
		self.hotkey = hs.hotkey.bind(mods, key, function()
			self:toggleMicMute()
			self.time_since_mute = hs.timer.secondsSinceEpoch()
		end, function()
			if hs.timer.secondsSinceEpoch() > self.time_since_mute + latch_timeout then
				self:toggleMicMute()
			end
		end)
	else
		self.hotkey = hs.hotkey.bind(mods, key, function()
			self:toggleMicMute()
		end)
	end

	return self
end


function obj:init()
	obj.time_since_mute = 0
	obj.mute_menu = hs.menubar.new()
	obj.mute_menu:setClickCallback(function()
		obj:toggleMicMute()
	end)
	obj:updateMicMute(-1)

	hs.audiodevice.watcher.setCallback(function(arg)
		if string.find(arg, "dIn ") then
			obj:updateMicMute(-1)
		end
	end)
	hs.audiodevice.watcher.start()
end

return obj
