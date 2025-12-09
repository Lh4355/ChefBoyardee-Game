--[[
	File: src/states/gameover.lua
	Description: Game Over State - Displays the game over screen with restart option.
--]]

local VolumeWidget = require("src.system.volume_widget")

local GameOver = {}

local function drawCenteredText(text, y, color)
	local r, g, b = unpack(color or { 1, 1, 1 })
	love.graphics.setColor(r, g, b)
	love.graphics.printf(text, 0, y, love.graphics.getWidth(), "center")
end

function GameOver.enter()
	VolumeWidget.setAnchor(nil, nil)
end

function GameOver.update(dt)
	VolumeWidget.update(dt)
end

function GameOver.draw()
	love.graphics.clear(0, 0, 0)
	drawCenteredText("YUCK! YOU ARE INEDIBLE!", 250, { 1, 0, 0 })
	drawCenteredText("Press 'R' to Restart", 300)

	VolumeWidget.draw()
end

function GameOver.keypressed(key)
	if key == "r" then
		love.event.quit("restart") -- restarts game back to main menu (relaunches the game)
	end
end

function GameOver.mousepressed(x, y, button)
	if VolumeWidget.mousepressed(x, y, button) then
		return
	end
end

return GameOver
