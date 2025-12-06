-- src/minigames/click_filler.lua
local ClickFiller = {}
ClickFiller.__index = ClickFiller

function ClickFiller.new(config)
    local instance = setmetatable({}, ClickFiller)

    -- 1. IMAGE & SPRITE CONFIG
    instance.imagePath = config.imagePath
    instance.image = nil
    instance.x = config.x
    instance.y = config.y
    instance.scale = config.scale or 1
    
    -- 2. GAMEPLAY SETTINGS
    instance.val = 0
    instance.max = config.max or 100
    instance.decay = config.decay or 30
    instance.add = config.add or 15
    instance.winNode = config.winNode
    instance.winMsg = config.winMsg or "Success!"
    
    -- 3. SHAKE SETTINGS (New!)
    -- Controls how violently the can shakes
    instance.shakeIntensity = config.shakeIntensity or 0.5 
    instance.shakeSpeed = config.shakeSpeed or 30

    -- 4. UI: BAR CONFIGURATION
    instance.prompt = config.prompt or "CLICK ME!"
    instance.barWidth = config.barWidth or 200
    instance.barHeight = config.barHeight or 20
    instance.barX = config.barX 
    instance.barY = config.barY 

    -- 5. UI: COLORS (Format: {r, g, b, a})
    -- Defaults: Green bar, Black bg, White text, No border
    instance.barColor = config.barColor or {0, 1, 0, 1}
    instance.barBgColor = config.barBgColor or {0, 0, 0, 0.7} 
    instance.borderColor = config.borderColor -- If nil, no border drawn
    instance.borderWidth = config.borderWidth or 2
    instance.textColor = config.textColor or {1, 1, 1, 1}

    -- 6. UI: FONT (New!)
    instance.fontSize = config.fontSize or 12
    instance.fontPath = config.fontPath -- Optional: Path to .ttf file
    
    -- Load Font logic
    if instance.fontPath then
        -- Load custom font at specified size
        local status, result = pcall(love.graphics.newFont, instance.fontPath, instance.fontSize)
        if status then instance.font = result end
    elseif instance.fontSize ~= 12 then
        -- Load default font at custom size
        instance.font = love.graphics.newFont(instance.fontSize)
    end
    -- If neither, we just use love.graphics.getFont() default later

    -- Load Image logic
    if instance.imagePath then
        local status, result = pcall(love.graphics.newImage, instance.imagePath)
        if status then instance.image = result end
    end

    return instance
end

function ClickFiller:update(dt)
    if self.val >= self.max then
        return true, self.winNode, self.winMsg
    end

    if self.val > 0 then
        self.val = self.val - (self.decay * dt)
        if self.val < 0 then self.val = 0 end
    end
    return false
end

function ClickFiller:draw()
    local w, h = love.graphics.getDimensions()

    -- A. DRAW IMAGE
    if self.image then
        local imgW, imgH = self.image:getDimensions()
        local drawX = self.x or (w / 2)
        local drawY = self.y or (h / 2)
        local drawScale = self.scale or 1

        -- Use configured shake settings
        local currentShake = (self.val / self.max) * self.shakeIntensity
        local rotation = math.sin(love.timer.getTime() * self.shakeSpeed) * currentShake

        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.image, drawX, drawY, rotation, drawScale, drawScale, imgW / 2, imgH / 2)
    end

    -- B. DRAW UI (Only if active)
    if self.val > 0 then
        local bx = self.barX or (w / 2 - self.barWidth / 2)
        local by = self.barY or (h - 100)

        -- 1. Draw Background
        love.graphics.setColor(unpack(self.barBgColor))
        love.graphics.rectangle("fill", bx, by, self.barWidth, self.barHeight)

        -- 2. Draw Fill
        love.graphics.setColor(unpack(self.barColor))
        local fillWidth = self.barWidth * (self.val / self.max)
        love.graphics.rectangle("fill", bx, by, fillWidth, self.barHeight)

        -- 3. Draw Border (If configured)
        if self.borderColor then
            love.graphics.setColor(unpack(self.borderColor))
            love.graphics.setLineWidth(self.borderWidth)
            love.graphics.rectangle("line", bx, by, self.barWidth, self.barHeight)
        end

        -- 4. Draw Text
        love.graphics.setColor(unpack(self.textColor))
        
        -- Apply custom font if we loaded one
        local oldFont = love.graphics.getFont()
        if self.font then love.graphics.setFont(self.font) end
        
        -- Center text slightly below the bar
        love.graphics.printf(self.prompt, bx, by + self.barHeight + 5, self.barWidth, "center")
        
        -- Reset font
        love.graphics.setFont(oldFont)
    end
    
    love.graphics.setColor(1, 1, 1) -- Reset color globally
end

function ClickFiller:mousepressed(x, y)
    if not self.image then return false end

    local w, h = love.graphics.getDimensions()
    local imgW, imgH = self.image:getDimensions()
    local centerX = self.x or (w / 2)
    local centerY = self.y or (h / 2)
    local checkScale = self.scale or 1
    local scaledHalfW = (imgW * checkScale) / 2
    local scaledHalfH = (imgH * checkScale) / 2

    if x >= centerX - scaledHalfW and x <= centerX + scaledHalfW and
       y >= centerY - scaledHalfH and y <= centerY + scaledHalfH then
        self.val = self.val + self.add
        if self.val > self.max then self.val = self.max end
        return true
    end
    return false
end

return ClickFiller