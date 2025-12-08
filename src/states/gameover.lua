-- src/states/gameover.lua
local VolumeWidget = require("src.system.volume_widget")

local GameOver = {}

function GameOver.enter()
	VolumeWidget.setAnchor(nil, nil)
end

function GameOver.update(dt)
	VolumeWidget.update(dt)
end

function GameOver.draw()
	love.graphics.clear(0, 0, 0)
	love.graphics.setColor(1, 0, 0)
	love.graphics.printf("YOU ARE EXPIRED (GAME OVER)", 0, 250, 800, "center")
	love.graphics.setColor(1, 1, 1)
	love.graphics.printf("Press 'R' to Restart", 0, 300, 800, "center")

	VolumeWidget.draw()
end

function GameOver.keypressed(key)
	if key == "r" then
		love.event.quit("restart") -- Simplest way to restart the whole game
	end
end

function GameOver.mousepressed(x, y, button)
	if VolumeWidget.mousepressed(x, y, button) then
		return
	end
end

return GameOver
