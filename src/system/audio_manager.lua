--[[
	File: src/system/audio_manager.lua
	Description: Manages all audio initialization, playback, and volume control for the game.
--]]

-- Create the AudioManager table
local AudioManager = {} 

local musicSource
local currentVolume = 0.5

--- Initialize audio and play background music
function AudioManager.initializeAudio()
	
	-- "stream" tells Love2D to stream it from the disk (good for long music) - doesn't load the entire file into memory at once, saving RAM.
	-- "static" would be used for short sound effects (keeps it in memory)

	-- Load and play background music if not already playing
	if not musicSource then
		musicSource = love.audio.newSource("src/data/audio/chef_music.mp3", "stream")
		musicSource:setLooping(true)
		musicSource:setVolume(currentVolume)
		musicSource:play()
	end
	-- Set the global volume
	love.audio.setVolume(currentVolume)
	return musicSource
end

--- Apply a new master volume between [0, 1]
---@param volume number
function AudioManager.setVolume(volume)
	currentVolume = math.max(0, math.min(1, volume or currentVolume))
	love.audio.setVolume(currentVolume)
	if musicSource then
		musicSource:setVolume(currentVolume)
	end
end

--- Get the current volume between [0, 1]
---@return number
function AudioManager.getVolume()
	return currentVolume
end

return AudioManager
