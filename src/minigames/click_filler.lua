-- src/minigames/click_filler.lua
local ClickFiller = {}
ClickFiller.__index = ClickFiller

-- Constructor: accepts a table of settings (config)
function ClickFiller.new(config)
	local instance = setmetatable({}, ClickFiller)

	instance.imagePath = config.imagePath
	instance.image = nil

	-- Game settings
	instance.val = 0
	instance.max = config.max or 100
	instance.decay = config.decay or 30
	instance.add = config.add or 15
	instance.winNode = config.winNode
	instance.winMsg = config.winMsg or "Success!"
	instance.prompt = config.prompt or "CLICK ME!"

	-- Sprite Position and Scale
	instance.x = config.x
	instance.y = config.y
	instance.scale = config.scale or 1

	-- [NEW] Bar Configuration (with defaults if not provided)
	instance.barWidth = config.barWidth or 200
	instance.barHeight = config.barHeight or 20
	-- If barX/barY are nil, we calculate them in the draw function relative to screen center
	instance.barX = config.barX
	instance.barY = config.barY

	-- [NEW] Colors (Default to Orange and White)
	-- format: {r, g, b, a}
	instance.barColor = config.barColor or { 1, 0.5, 0, 1 }
	instance.textColor = config.textColor or { 1, 1, 1, 1 }

	-- Load the image
	if instance.imagePath then
		local status, result = pcall(function()
			return love.graphics.newImage(instance.imagePath)
		end)

		if status then
			instance.image = result
		else
			print("ERROR: Could not load minigame image: " .. instance.imagePath)
		end
	end

	return instance
end

function ClickFiller:update(dt)
	if self.val >= self.max then
		return true, self.winNode, self.winMsg
	end

	if self.val > 0 then
		self.val = self.val - (self.decay * dt)
		if self.val < 0 then
			self.val = 0
		end
	end

	return false
end

function ClickFiller:draw()
	local w, h = love.graphics.getDimensions()

	-- 1. Draw The Can Sprite
	if self.image then
		local imgW, imgH = self.image:getDimensions()
		local drawX = self.x or (w / 2)
		local drawY = self.y or (h / 2)
		local drawScale = self.scale or 1

		-- Calculate shake
		local shakeIntensity = (self.val / self.max) * 0.5
		local rotation = math.sin(love.timer.getTime() * 30) * shakeIntensity

		love.graphics.setColor(1, 1, 1)
		love.graphics.draw(self.image, drawX, drawY, rotation, drawScale, drawScale, imgW / 2, imgH / 2)
	end
    
	-- 2. Draw The UI (Only if active)
	-- Check if val > 0. If it is 0, the bar is hidden.
	if self.val > 0 then
		-- 2. Draw The Wobble Bar
		-- Determine Position: Use config if provided, otherwise default to bottom center
		local bx = self.barX or (w / 2 - self.barWidth / 2)
		local by = self.barY or (h - 100)

		-- Draw Background (Black transparent)
		love.graphics.setColor(0, 0, 0, 0.7)
		love.graphics.rectangle("fill", bx, by, self.barWidth, self.barHeight)

		-- Draw Foreground (Dynamic Color)
		love.graphics.setColor(unpack(self.barColor))
		love.graphics.rectangle("fill", bx, by, self.barWidth * (self.val / self.max), self.barHeight)

		-- 3. Draw Text
		love.graphics.setColor(unpack(self.textColor))
		-- Text is centered on the bar, slightly below it
		love.graphics.printf(self.prompt, bx, by + 25, self.barWidth, "center")
	end
end

function ClickFiller:mousepressed(x, y)
	if not self.image then
		return false
	end

	local w, h = love.graphics.getDimensions()
	local imgW, imgH = self.image:getDimensions()

	-- Safety Check: Ensure we have defaults
	local centerX = self.x or (w / 2)
	local centerY = self.y or (h / 2)
	local checkScale = self.scale or 1

	local scaledHalfW = (imgW * checkScale) / 2
	local scaledHalfH = (imgH * checkScale) / 2

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
