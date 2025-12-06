-- src/menu.lua
local Menu = {}

local background_image

function Menu.enter()
	background_image = love.graphics.newImage("src/data/images/image1.png")
end

function Menu.update(dt)
	-- Add animation logic here later (e.g., bouncing text)
end

function Menu.draw()
	local windowWidth = love.graphics.getWidth()
	local windowHeight = love.graphics.getHeight()

	love.graphics.setColor(1, 1, 1) -- White

	-- Draw the background image FIRST (so it sits behind the text)
    if background_image then
        -- Calculate scale factor to make image fit the screen
        local sx = windowWidth / background_image:getWidth()
        local sy = windowHeight / background_image:getHeight()
        
        -- Draw image at 0,0 with scale factors sx and sy
        love.graphics.draw(background_image, 0, 0, 0, sx, sy)
    end

	-- Draw Title (Centered)
	local title = "The Rolling Can"
	local font = love.graphics.getFont()
	local titleWidth = font:getWidth(title)

	love.graphics.setColor(0, 0, 0) -- Black shadow?
    love.graphics.print(title, (windowWidth - titleWidth) / 2 + 2, 202)
    
    love.graphics.setColor(1, 1, 1) -- White text
    love.graphics.print(title, (windowWidth - titleWidth) / 2, 200)

	-- Draw Instruction
	local text = "Press ENTER or CLICK to Start"
	local textWidth = font:getWidth(text)
	love.graphics.print(text, (windowWidth - textWidth) / 2, 300)
end

function Menu.mousepressed(x, y, button)
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
