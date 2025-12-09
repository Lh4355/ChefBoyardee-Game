--[[
	File: src/states/menu.lua
	Description: Main menu state for The Rolling Can game. Renders the menu background, 
				 title, instructions, music credit, and volume widget. Provides input 
				 handling for starting the game (ENTER, SPACE, or mouse click) and 
				 interacting with the volume control.
--]]

local VolumeWidget = require("src.system.volume_widget")
local Utils = require("src.utils")

local Menu = {}

local background_image
local title_font
local text_font
local music_font

-- Helper to draw centered text with font and color
local function drawCenteredText(text, y, font, color, shadow)
	if font then
		love.graphics.setFont(font)
	end
	local currentFont = love.graphics.getFont()
	local textWidth = currentFont:getWidth(text)
	if shadow then
		love.graphics.setColor(0, 0, 0)
		love.graphics.print(text, (love.graphics.getWidth() - textWidth) / 2 + 3, y + 3)
	end
	love.graphics.setColor(color[1], color[2], color[3])
	love.graphics.print(text, (love.graphics.getWidth() - textWidth) / 2, y)
end

function Menu.enter()
	-- Load Background Image
	background_image = love.graphics.newImage("src/data/images/locations/main_menu.png")
	-- Load the Hobbit-style fonts
	title_font = Utils.loadFont("src/data/fonts/RINGM___.TTF", 60)
	text_font = Utils.loadFont("src/data/fonts/RINGM___.TTF", 20)
	music_font = Utils.loadFont("src/data/fonts/friz-quadrata-regular.ttf", 15)

	VolumeWidget.init()
	-- Anchor on top area, right side like cream bar
	local w = love.graphics.getWidth()
	local buttonSize = VolumeWidget.getButtonSize()
	VolumeWidget.setAnchor(w - 12 - buttonSize, 8)
end

function Menu.update(dt)
	-- Add animation logic here later (e.g., bouncing text)
	VolumeWidget.update(dt)
end

function Menu.draw()
	local windowWidth = love.graphics.getWidth()
	local windowHeight = love.graphics.getHeight()

	love.graphics.setColor(1, 1, 1)
	-- Draw Background
	if background_image then
		local sx = windowWidth / background_image:getWidth()
		local sy = windowHeight / background_image:getHeight()
		love.graphics.draw(background_image, 0, 0, 0, sx, sy)
	end

	-- Draw Title with shadow
	drawCenteredText("The Rolling Can", 200, title_font, { 1, 0.8, 0.2 }, true)

	-- Draw Instruction
	drawCenteredText("Press ENTER or CLICK to Start", 350, text_font, { 1, 1, 1 })

	-- Music Credit (bottom left)
	love.graphics.setFont(music_font)
	love.graphics.setColor(1, 0.8, 0.2)
	love.graphics.print("Song: Un p'tit air by Tetes Raides", 10, windowHeight - 20)

	-- Volume control (bottom-right)
	VolumeWidget.draw()
end

function Menu.mousepressed(x, y, button)
	if VolumeWidget.mousepressed(x, y, button) then
		return nil
	end

	if button == 1 then
		return "explore" -- Signal to switch state
	end
	return nil
end

function Menu.keypressed(key)
	if key == "return" or key == "space" then
		return "explore" -- Signal to switch state
	end
	return nil
end

return Menu
