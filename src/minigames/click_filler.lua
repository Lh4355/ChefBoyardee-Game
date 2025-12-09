--[[ 
    File: /src/minigames/click_filler.lua
    Description: Click Filler Minigame - A minigame where the player clicks on an image 
                 to fill a progress bar, with decay over time. Upon filling the bar, a 
                 win condition is triggered.
--]]

local ClickFiller = {}
ClickFiller.__index = ClickFiller

-- Creates a new ClickFiller instance with the provided configuration
function ClickFiller.new(config)
	local instance = setmetatable({}, ClickFiller)

	-- Image display configuration
	instance.imagePath = config.imagePath
	instance.image = nil
	instance.x = config.x
	instance.y = config.y
	instance.scale = config.scale or 1

	-- Gameplay mechanics: progress tracking and win conditions
	instance.val = 0
	instance.max = config.max or 100
	instance.decay = config.decay or 30
	instance.add = config.add or 15
	instance.winNode = config.winNode
	instance.winMsg = config.winMsg or "Success!"

	-- Visual feedback: shake effect increases with progress
	instance.shakeIntensity = config.shakeIntensity or 0.5
	instance.shakeSpeed = config.shakeSpeed or 30

	-- Progress bar dimensions and positioning
	instance.prompt = config.prompt or "CLICK ME!"
	instance.barWidth = config.barWidth or 200
	instance.barHeight = config.barHeight or 20
	instance.barX = config.barX
	instance.barY = config.barY

	-- Color scheme: RGBA format
	instance.barColor = config.barColor or { 0, 1, 0, 1 }
	instance.barBgColor = config.barBgColor or { 0, 0, 0, 0.7 }
	instance.borderColor = config.borderColor
	instance.borderWidth = config.borderWidth or 2
	instance.textColor = config.textColor or { 1, 1, 1, 1 } -- Font configuration: custom or default
	instance.fontSize = config.fontSize or 12
	instance.fontPath = config.fontPath

	-- Load custom font if specified, otherwise use sized default
	if instance.fontPath then
		local status, result = pcall(love.graphics.newFont, instance.fontPath, instance.fontSize)
		if status then
			instance.font = result
		end
	elseif instance.fontSize ~= 12 then
		instance.font = love.graphics.newFont(instance.fontSize)
	end

	-- Load clickable image asset
	if instance.imagePath then
		local status, result = pcall(love.graphics.newImage, instance.imagePath)
		if status then
			instance.image = result
		end
	end

	return instance
end

-- Updates game state: checks win condition and applies decay
-- Returns: success (bool), winNode, winMsg on completion
function ClickFiller:update(dt)
	-- Check if player has filled the bar completely
	if self.val >= self.max then
		return true, self.winNode, self.winMsg
	end

	-- Apply decay over time
	if self.val > 0 then
		self.val = self.val - (self.decay * dt)
		if self.val < 0 then
			self.val = 0
		end
	end
	return false
end

-- Renders the clickable image and progress UI
function ClickFiller:draw()
	local w, h = love.graphics.getDimensions()

	-- Draw centered image with shake effect based on progress
	if self.image then
		local imgW, imgH = self.image:getDimensions()
		local drawX = self.x or (w / 2)
		local drawY = self.y or (h / 2)
		local drawScale = self.scale or 1

		-- Calculate shake rotation proportional to fill percentage
		local currentShake = (self.val / self.max) * self.shakeIntensity
		local rotation = math.sin(love.timer.getTime() * self.shakeSpeed) * currentShake

		love.graphics.setColor(1, 1, 1)
		love.graphics.draw(self.image, drawX, drawY, rotation, drawScale, drawScale, imgW / 2, imgH / 2)
	end

	-- Draw progress bar and prompt only when active
	if self.val > 0 then
		local bx = self.barX or (w / 2 - self.barWidth / 2)
		local by = self.barY or (h - 100)

		-- Draw bar background
		love.graphics.setColor(unpack(self.barBgColor))
		love.graphics.rectangle("fill", bx, by, self.barWidth, self.barHeight)

		-- Draw progress fill
		love.graphics.setColor(unpack(self.barColor))
		local fillWidth = self.barWidth * (self.val / self.max)
		love.graphics.rectangle("fill", bx, by, fillWidth, self.barHeight)

		-- Draw optional border
		if self.borderColor then
			love.graphics.setColor(unpack(self.borderColor))
			love.graphics.setLineWidth(self.borderWidth)
			love.graphics.rectangle("line", bx, by, self.barWidth, self.barHeight)
		end

		-- Draw prompt text below bar
		love.graphics.setColor(unpack(self.textColor))

		local oldFont = love.graphics.getFont()
		if self.font then
			love.graphics.setFont(self.font)
		end

		love.graphics.printf(self.prompt, bx, by + self.barHeight + 5, self.barWidth, "center")

		love.graphics.setFont(oldFont)
	end

	love.graphics.setColor(1, 1, 1)
end

-- Handles mouse clicks: increases progress if clicking on the image
-- Returns: true if click was within bounds, false otherwise
function ClickFiller:mousepressed(x, y)
	if not self.image then
		return false
	end

	local w, h = love.graphics.getDimensions()
	local imgW, imgH = self.image:getDimensions()
	local centerX = self.x or (w / 2)
	local centerY = self.y or (h / 2)
	local checkScale = self.scale or 1
	local scaledHalfW = (imgW * checkScale) / 2
	local scaledHalfH = (imgH * checkScale) / 2

	-- Check if click is within image bounds
	if
		x >= centerX - scaledHalfW
		and x <= centerX + scaledHalfW
		and y >= centerY - scaledHalfH
		and y <= centerY + scaledHalfH
	then
		self.val = self.val + self.add
		if self.val > self.max then
			self.val = self.max
		end
		return true
	end
	return false
end

return ClickFiller
