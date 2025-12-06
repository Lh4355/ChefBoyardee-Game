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

	-- NEW: Position and Scale Configuration
	-- We default scale to 1 if not provided
	instance.x = config.x
	instance.y = config.y
	instance.scale = config.scale or 1

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
	if not self.image then
		return
	end

	local w, h = love.graphics.getDimensions()
	local imgW, imgH = self.image:getDimensions()

	-- Safety Check: Ensure we have defaults if x/y/scale are missing
	local drawX = self.x or (w / 2)
	local drawY = self.y or (h / 2)
	local drawScale = self.scale or 1

	-- Calculate shake
	local shakeIntensity = (self.val / self.max) * 0.5
	local rotation = math.sin(love.timer.getTime() * 30) * shakeIntensity

	-- Draw Image at specific X/Y with specific Scale
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(self.image, drawX, drawY, rotation, drawScale, drawScale, imgW / 2, imgH / 2)

	-- Draw UI Elements (Keeping these centered on screen for readability)
	love.graphics.setColor(0, 0, 0, 0.7)
	love.graphics.rectangle("fill", w / 2 - 100, h - 100, 200, 20)

	love.graphics.setColor(1, 0.5, 0)
	love.graphics.rectangle("fill", w / 2 - 100, h - 100, 200 * (self.val / self.max), 20)

	love.graphics.setColor(1, 1, 1)
	love.graphics.printf(self.prompt, w / 2 - 100, h - 75, 200, "center")
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

	-- Calculate hitbox based on scale
	-- The arithmetic error happened here because checkScale was nil
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
