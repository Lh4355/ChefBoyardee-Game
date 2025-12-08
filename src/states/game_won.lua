-- src/states/game_won.lua
local InputManager = require("src.system.input_manager")
local GameState = require("src.system.game_state")
local VolumeWidget = require("src.system.volume_widget")

local Won = {}

-- Win UI Constants
local BUTTON_WIDTH = 200
local BUTTON_HEIGHT = 60
local BUTTON_X = 300
local BUTTON_Y = 300

local gameFlags, player, nodes
local victory_image

function Won.enter(pPlayer, pNodes)
	player = pPlayer
	nodes = pNodes
	gameFlags = GameState.new()
	VolumeWidget.init()
	VolumeWidget.setAnchor(nil, nil)

	-- Load background image
	victory_image = love.graphics.newImage("src/data/images/locations/victory_bowl.png")
end

function Won.update(dt)
	VolumeWidget.update(dt)
end

function Won.draw()
	local w, h = love.graphics.getDimensions()

	-- Draw background image
	if victory_image then
		local sx = w / victory_image:getWidth()
		local sy = h / victory_image:getHeight()
		love.graphics.draw(victory_image, 0, 0, 0, sx, sy)
	end

	-- Darken the background overlay
	love.graphics.setColor(0, 0, 0, 0.5)
	love.graphics.rectangle("fill", 0, 0, w, h)

	-- Draw "You Won!" text
	love.graphics.setColor(1, 1, 0) -- Yellow
	local font = love.graphics.newFont("src/data/fonts/friz-quadrata-regular.ttf", 72)
	love.graphics.setFont(font)
	love.graphics.printf("You Won!", 0, 200, w, "center")

	-- Draw Main Menu button
	local buttonX = BUTTON_X
	local buttonY = BUTTON_Y
	local buttonW = BUTTON_WIDTH
	local buttonH = BUTTON_HEIGHT

	-- Button background
	love.graphics.setColor(0.2, 0.5, 0.2) -- Dark green
	love.graphics.rectangle("fill", buttonX, buttonY, buttonW, buttonH)

	-- Button border
	love.graphics.setColor(0, 1, 0) -- Bright green
	love.graphics.setLineWidth(3)
	love.graphics.rectangle("line", buttonX, buttonY, buttonW, buttonH)

	-- Button text
	love.graphics.setColor(1, 1, 1) -- White
	local buttonFont = love.graphics.newFont("src/data/fonts/friz-quadrata-regular.ttf", 24)
	love.graphics.setFont(buttonFont)
	love.graphics.printf("Main Menu", buttonX, buttonY + 17, buttonW, "center")

	-- Register button click zone
	InputManager.clear()
	InputManager.register(buttonX, buttonY, buttonW, buttonH, "main_menu", nil)

	love.graphics.setColor(1, 1, 1, 1) -- Reset color

	VolumeWidget.draw()
end

function Won.mousepressed(x, y, button)
	if VolumeWidget.mousepressed(x, y, button) then
		return
	end

	if button == 1 then
		local type, data = InputManager.handleMousePressed(x, y)
		if type == "main_menu" then
			-- Reset game state and return to menu
			gameFlags:reset(player, nodes)
			return "menu"
		end
	end
end

return Won
