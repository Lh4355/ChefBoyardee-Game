--[[
	File: src/states/game_won.lua
	Description: Game Won State - Displays the victory screen with option to return to main menu.
--]]

local InputManager = require("src.system.input_manager")
local GameState = require("src.system.game_state")
local VolumeWidget = require("src.system.volume_widget")

local Won = {}

-- Win UI Constants
local FONT_PATH = "src/data/fonts/friz-quadrata-regular.ttf"
local BUTTON_WIDTH = 200
local BUTTON_HEIGHT = 60
local BUTTON_X = 300
local BUTTON_Y = 300

local COLORS = {
	title = { 1, 1, 0 },
	buttonFill = { 0.2, 0.5, 0.2 },
	buttonBorder = { 0, 1, 0 },
	buttonText = { 1, 1, 1 },
	overlay = { 0, 0, 0, 0.5 },
	reset = { 1, 1, 1, 1 },
}

local gameFlags, player, nodes
local victory_image, titleFont, buttonFont

local function setColor(color)
	love.graphics.setColor(color[1], color[2], color[3], color[4] or 1)
end

local function drawVictoryText(screenW)
	setColor(COLORS.title)
	love.graphics.setFont(titleFont)
	love.graphics.printf("You Won!", 0, 200, screenW, "center")
end

local function drawMainMenuButton()
	InputManager.clear()

	setColor(COLORS.buttonFill)
	love.graphics.rectangle("fill", BUTTON_X, BUTTON_Y, BUTTON_WIDTH, BUTTON_HEIGHT)

	setColor(COLORS.buttonBorder)
	love.graphics.setLineWidth(3)
	love.graphics.rectangle("line", BUTTON_X, BUTTON_Y, BUTTON_WIDTH, BUTTON_HEIGHT)

	setColor(COLORS.buttonText)
	love.graphics.setFont(buttonFont)
	love.graphics.printf("Main Menu", BUTTON_X, BUTTON_Y + 17, BUTTON_WIDTH, "center")

	InputManager.register(BUTTON_X, BUTTON_Y, BUTTON_WIDTH, BUTTON_HEIGHT, "main_menu", nil)
end

function Won.enter(pPlayer, pNodes)
	player = pPlayer
	nodes = pNodes
	gameFlags = GameState.new()
	VolumeWidget.init()
	VolumeWidget.setAnchor(nil, nil)
	titleFont = love.graphics.newFont(FONT_PATH, 72)
	buttonFont = love.graphics.newFont(FONT_PATH, 24)

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
	setColor(COLORS.overlay)
	love.graphics.rectangle("fill", 0, 0, w, h)

	-- Draw "You Won!" text
	drawVictoryText(w)

	-- Draw Main Menu button
	drawMainMenuButton()

	setColor(COLORS.reset)

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
