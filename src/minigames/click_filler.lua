-- src/minigames/click_filler.lua
local ClickFiller = {}
ClickFiller.__index = ClickFiller

-- Constructor: accepts a table of settings (config)
function ClickFiller.new(config)
	local instance = setmetatable({}, ClickFiller)

	instance.imagePath = config.imagePath
	instance.image = nil -- Load this later to be safe

	-- Game settings (use defaults if not provided)
	instance.val = 0
	instance.max = config.max or 100
	instance.decay = config.decay or 30 -- How fast it drains
	instance.add = config.add or 15 -- How much per click
	instance.winNode = config.winNode -- Where to go when you win
	instance.winMsg = config.winMsg or "Success!"
	instance.prompt = config.prompt or "CLICK ME!"

	-- Load the image immediately if possible
	if instance.imagePath then
		-- Change this block to print errors if loading fails
		local status, result = pcall(function()
			return love.graphics.newImage(instance.imagePath)
		end)

		if status then
			instance.image = result
		else
			print("ERROR: Could not load minigame image: " .. instance.imagePath)
			print("Reason: " .. tostring(result))
		end
	end

	return instance
end

function ClickFiller:update(dt)
	-- Check Win Condition
	if self.val >= self.max then
		return true, self.winNode, self.winMsg
	end

	-- Decay the bar
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

	-- Calculate shake based on how full the bar is
	local shakeIntensity = (self.val / self.max) * 0.5
	local rotation = math.sin(love.timer.getTime() * 30) * shakeIntensity

	-- Draw Image Centered
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(self.image, w / 2, h / 2, rotation, 1, 1, imgW / 2, imgH / 2)

	-- Draw Bar Background
	love.graphics.setColor(0, 0, 0, 0.7)
	love.graphics.rectangle("fill", w / 2 - 100, h / 2 + 200, 200, 20)

	-- Draw Bar Fill (Orange)
	love.graphics.setColor(1, 0.5, 0)
	love.graphics.rectangle("fill", w / 2 - 100, h / 2 + 200, 200 * (self.val / self.max), 20)

	-- Draw Prompt Text
	love.graphics.setColor(1, 1, 1)
	love.graphics.printf(self.prompt, w / 2 - 100, h / 2 + 225, 200, "center")
end

-- Returns true if clicked
function ClickFiller:mousepressed(x, y)
	if not self.image then
		return false
	end

	local w, h = love.graphics.getDimensions()
	local imgW, imgH = self.image:getDimensions()

	-- Hitbox check (centered image)
	local startX = w / 2 - imgW / 2
	local startY = h / 2 - imgH / 2

	if x >= startX and x <= startX + imgW and y >= startY and y <= startY + imgH then
		self.val = self.val + self.add
		if self.val > self.max then
			self.val = self.max
		end
		return true
	end

	return false
end

return ClickFiller
