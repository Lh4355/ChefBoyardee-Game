-- src/menu.lua
local Menu = {}

function Menu.update(dt)
	-- Add animation logic here later (e.g., bouncing text)
end

function Menu.draw()
	local windowWidth = love.graphics.getWidth()
	local windowHeight = love.graphics.getHeight()

	love.graphics.setColor(1, 1, 1) -- White

	-- Draw Title (Centered)
	local title = "The Rolling Can"
	local font = love.graphics.getFont()
	local titleWidth = font:getWidth(title)
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
