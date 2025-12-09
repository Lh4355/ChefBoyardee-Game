-- src/menu.lua
local VolumeWidget = require("src.system.volume_widget")
local Utils = require("src.utils")

local Menu = {}

local background_image
local title_font
local text_font
local music_font

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

	love.graphics.setColor(1, 1, 1) -- White

	-- 1. Draw Background
	if background_image then
		local sx = windowWidth / background_image:getWidth()
		local sy = windowHeight / background_image:getHeight()
		love.graphics.draw(background_image, 0, 0, 0, sx, sy)
	end

	-- 2. Draw Title
	local title = "The Rolling Can"

	-- Set Title Font
	if title_font then
		love.graphics.setFont(title_font)
	end

	-- Calculate Title Width using the current font
	local currentFont = love.graphics.getFont()
	local titleWidth = currentFont:getWidth(title)

	-- Draw Shadow & Title
	love.graphics.setColor(0, 0, 0)
	love.graphics.print(title, (windowWidth - titleWidth) / 2 + 3, 203)

	love.graphics.setColor(1, 0.8, 0.2) -- Gold
	love.graphics.print(title, (windowWidth - titleWidth) / 2, 200)

	-- 3. Draw Instruction
	local text = "Press ENTER or CLICK to Start"

	-- Switch to Text Font
	if text_font then
		love.graphics.setFont(text_font)
	end

	-- Update the font variable to the NEW font before calculating width
	currentFont = love.graphics.getFont()
	local textWidth = currentFont:getWidth(text)

	love.graphics.setColor(1, 1, 1) -- White
	love.graphics.print(text, (windowWidth - textWidth) / 2, 350)

	-- Add this after the title drawing code (around line 60)

	--  Music Credit
	local music_credit = "Song: Un p'tit air by Tetes Raides"

	love.graphics.setFont(music_font) -- Use the smaller font
	love.graphics.setColor(1, 0.8, 0.2) -- gold
	love.graphics.print(music_credit, 10, 580)

	-- FIXME: where should i put this to reset font for small text later?
	love.graphics.setFont(love.graphics.newFont(12)) -- Uncomment to reset font for small text

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
