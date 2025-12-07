-- src/system/audio_manager.lua
-- Handles all audio initialization and management

local AudioManager = {}

--- Initialize audio and play background music
function AudioManager.initializeAudio()
	-- "stream" tells Love2D to stream it from the disk (good for long music)
	-- "static" would be used for short sound effects (keeps it in memory)
	local music = love.audio.newSource("src/data/audio/chef_music.mp3", "stream")
	music:setLooping(true) -- Make it repeat forever
	music:setVolume(0.0) -- FIXME: Muted for now, uncomment out line above to enable music and delete this line
	music:play()
	return music
end

return AudioManager
