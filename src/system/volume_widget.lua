--[[
	File: src/system/volume_widget.lua
	Description: Draws and handles the volume toggle + slider
--]]

-- Draws and handles the volume toggle + slider
local AudioManager = require("src.system.audio_manager")
local Utils = require("src.utils")

local VolumeWidget = {}

local buttonSize = 32
local margin = 12
local sliderWidth = 100
local sliderHeight = 12
local sliderPadding = 18
local isExpanded = false
local isDragging = false
local uiFont
local iconImage
local anchorX, anchorY

local colors = {
	button = { 0.18, 0.42, 0.25, 1 }, -- dark green
	buttonBorder = { 0.35, 0.8, 0.35, 1 }, -- bright green
	track = { 0.65, 0.65, 0.65, 1 }, -- gray
}

--- loads 14px font on first use
local function ensureFont()
	if not uiFont then
		uiFont = Utils.loadFont("src/data/fonts/friz-quadrata-regular.ttf", 14)
	end
end

--- loads the speaker icon image on first use
local function ensureIcon()
	if iconImage ~= nil then
		return
	end
	iconImage = Utils.loadImage("src/data/images/sprites/Raw_Images/volume_icon.png")
end

--- Returns button rect (x, y, width, height)
-- Uses custom anchor if set, otherwise positions in bottom-right corner
local function getButtonRect()
	if anchorX and anchorY then
		return anchorX, anchorY, buttonSize, buttonSize
	end

	local w, h = love.graphics.getDimensions()
	local bx = w - margin - buttonSize
	local by = h - margin - buttonSize
	return bx, by, buttonSize, buttonSize
end

--- Returns slider rect (x, y, width, height)
-- Positions slider relative to button: left when anchored, above/below when floating
local function getSliderRect()
	local bx, by, bw, bh = getButtonRect()
	local _, h = love.graphics.getDimensions()
	local isAnchored = anchorX and anchorY

	-- When anchored (cream bar), slider is left of button at same Y; otherwise below/above
	local sx, sy
	if isAnchored then
		sx = bx - sliderWidth - 8
		sy = by + (bh - sliderHeight) / 2
	else
		local expandDown = by < (h / 2)
		sx = bx - sliderWidth + bw
		sy = expandDown and (by + bh + sliderPadding) or (by - sliderHeight - sliderPadding)
	end

	return sx, sy, sliderWidth, sliderHeight
end

--- Converts mouse X position to volume (0.0-1.0) and updates AudioManager
local function setVolumeFromX(x)
	local sx, _, sw = getSliderRect()
	local clamped = math.max(sx, math.min(sx + sw, x))
	local t = (clamped - sx) / sw
	AudioManager.setVolume(t)
end

--- Initializes the widget by pre-loading font and icon
function VolumeWidget.init()
	ensureFont()
	ensureIcon()
end

--- Updates widget state each frame (handles slider dragging)
function VolumeWidget.update(dt)
	if isDragging and love.mouse.isDown(1) then
		local mx = love.mouse.getPosition()
		setVolumeFromX(mx)
	else
		isDragging = false
	end
end

--- Renders the button, icon, and slider (when expanded) on screen
function VolumeWidget.draw()
	ensureFont()
	ensureIcon()
	local bx, by, bw, bh = getButtonRect()
	local volume = AudioManager.getVolume()

	-- Button Background
	love.graphics.setColor(colors.button)
	love.graphics.rectangle("fill", bx, by, bw, bh, 6, 6)

	love.graphics.setLineWidth(2)
	love.graphics.setColor(colors.buttonBorder)
	love.graphics.rectangle("line", bx, by, bw, bh, 6, 6)

	-- Icon
	if iconImage and iconImage ~= false then
		love.graphics.setColor(1, 1, 1, 1)
		local iw, ih = iconImage:getDimensions()
		local scale = math.min((bw - 8) / iw, (bh - 8) / ih)
		local ox = iw / 2
		local oy = ih / 2
		love.graphics.draw(iconImage, bx + bw / 2, by + bh / 2, 0, scale, scale, ox, oy)
	end

	-- When expanded, draw slider
	if isExpanded then
		local sx, sy, sw, sh = getSliderRect()

		love.graphics.setColor(colors.track)
		love.graphics.rectangle("fill", sx, sy, sw, sh, 4, 4)

		love.graphics.setColor(colors.button)
		love.graphics.rectangle("fill", sx, sy, sw * volume, sh, 4, 4)

		-- Knob
		love.graphics.setColor(colors.buttonBorder)
		local knobX = sx + sw * volume
		love.graphics.circle("fill", knobX, sy + sh / 2, 7)
	end

	love.graphics.setColor(1, 1, 1, 1) -- reset
end

--- Handles mouse clicks: toggles expansion, drags slider, collapses on outside click
function VolumeWidget.mousepressed(x, y, button)
	if button ~= 1 then
		return false
	end

	local bx, by, bw, bh = getButtonRect()
	if Utils.checkCollision(x, y, 1, 1, bx, by, bw, bh) then
		isExpanded = not isExpanded
		isDragging = false
		return true
	end

	if isExpanded then
		local sx, sy, sw, sh = getSliderRect()
		local hitH = sh + 16 -- Slightly taller hitbox for comfort
		if Utils.checkCollision(x, y, 1, 1, sx, sy - 8, sw, hitH) then
			setVolumeFromX(x)
			isDragging = true
			return true
		end

		-- Clicked away from both button and slider: collapse
		isExpanded = false
		isDragging = false
		return true
	end

	return false
end

--- Set a custom button anchor (top-left of the button). Pass nil to reset to default bottom-right.
---@param x number|nil
---@param y number|nil
function VolumeWidget.setAnchor(x, y)
	anchorX = x
	anchorY = y
end

--- Expose the button size for layout helpers
function VolumeWidget.getButtonSize()
	return buttonSize
end

return VolumeWidget
