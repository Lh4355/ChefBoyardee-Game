-- src/system/audio_manager.lua
-- Handles all audio initialization and management

local AudioManager = {}

local musicSource
local currentVolume = 0.5

--- Initialize audio and play background music
function AudioManager.initializeAudio()
	-- "stream" tells Love2D to stream it from the disk (good for long music)
	-- "static" would be used for short sound effects (keeps it in memory)
	if not musicSource then
		musicSource = love.audio.newSource("src/data/audio/chef_music.mp3", "stream")
		musicSource:setLooping(true)
		musicSource:setVolume(currentVolume)
		musicSource:play()
	end
	-- Keep global audio volume in sync for future SFX
	love.audio.setVolume(currentVolume)
	return musicSource
end

--- Clamp and apply a new master volume [0, 1]
---@param volume number
function AudioManager.setVolume(volume)
	local v = math.max(0, math.min(1, volume or currentVolume))
	currentVolume = v
	love.audio.setVolume(currentVolume)
	if musicSource then
		musicSource:setVolume(currentVolume)
	end
end

--- Get the current volume [0, 1]
---@return number
function AudioManager.getVolume()
	return currentVolume
end

--- Retrieve the active music source (may be nil before initialization)
--@return love.Source|nil
-- function AudioManager.getMusicSource()
-- 	return musicSource
-- end

return AudioManager
