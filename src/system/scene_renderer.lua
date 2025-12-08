-- src/system/scene_renderer.lua
local Constants = require("src.constants")
local InputManager = require("src.system.input_manager")

local SceneRenderer = {}
local uiFontSmall
local arrowImage

-- Decide whether a navigation arrow should be visible for the current node.
local function isPathVisible(currentNode, pathName, flags)
	if currentNode and currentNode.id == 23 and pathName == "living_room" then
		return flags and flags.front_door_unlocked
	end

	return true
end

function SceneRenderer.init()
	-- Load font for paths
	local successSmall, fontSmall = pcall(love.graphics.newFont, "src/data/fonts/friz-quadrata-regular.ttf", 16)
	if successSmall then
		uiFontSmall = fontSmall
	else
		uiFontSmall = love.graphics.newFont(16)
	end

	-- Load arrow sprite
	arrowImage = love.graphics.newImage("src/data/images/sprites/arrow.png")
end

function SceneRenderer.drawBackground(currentNode)
	if currentNode.image then
		local w, h = love.graphics.getDimensions()
		local imageWidth = currentNode.image:getWidth()
		local imageHeight = currentNode.image:getHeight()
		local scaleX = w / imageWidth
		local scaleY = h / imageHeight
		love.graphics.setColor(1, 1, 1)
		love.graphics.draw(currentNode.image, 0, 0, 0, scaleX, scaleY)
	end
end

function SceneRenderer.drawElements(currentNode, gameFlags)
	if not uiFontSmall then
		SceneRenderer.init()
	end
	local gui = Constants.GUI

	-- 1. Draw Items
	for i, item in ipairs(currentNode.items) do
		local ix, iy = item.x or (100 + i * 60), item.y or 400
		local iw, ih = item.w or gui.item_scene_size, item.h or gui.item_scene_size

		-- Draw Blue Box
		love.graphics.setColor(0, 0, 1)
		love.graphics.rectangle("fill", ix, iy, iw, ih)
		love.graphics.setColor(1, 1, 1)
		love.graphics.print(item.name, ix, iy - 20)

		-- Register Click
		InputManager.register(ix, iy, iw, ih, "item", item.id)
	end

	-- 2. Draw Navigation Arrows
	local arrowSize = 48
	local arrowPadding = 60
	local defaultArrowY = 150
	local mouseX, mouseY = love.mouse.getPosition()
	love.graphics.setFont(uiFontSmall)
	local hoveredPath = nil

	local i = 0
	for pathName, targetId in pairs(currentNode.paths) do
		if not isPathVisible(currentNode, pathName, gameFlags) then
			goto continue
		end
		-- Use custom arrow data if available, otherwise use defaults
		local arrowData = currentNode.arrows and currentNode.arrows[pathName]
		local arrowX = (arrowData and arrowData.x) or (50 + i * (arrowSize + arrowPadding))
		local arrowY = (arrowData and arrowData.y) or defaultArrowY
		local arrowRotation = (arrowData and arrowData.rotation) or 0
		local arrowScale = (arrowData and arrowData.scale) or 1

		-- Calculate actual arrow size with scale
		local actualSize = arrowSize * arrowScale
		local scaleX = (actualSize / arrowImage:getWidth())
		local scaleY = (actualSize / arrowImage:getHeight())

		-- Calculate center offset for rotation pivot (center of the arrow image)
		local offsetX = arrowImage:getWidth() / 2
		local offsetY = arrowImage:getHeight() / 2

		-- Draw yellow arrow (rotates around its center)
		-- Position x,y is where the CENTER of the arrow will be drawn
		love.graphics.setColor(1, 1, 0)
		love.graphics.draw(arrowImage, arrowX, arrowY, arrowRotation, scaleX, scaleY, offsetX, offsetY)

		-- Register Click (adjust for bounding box around center point)
		local clickX = arrowX - actualSize / 2
		local clickY = arrowY - actualSize / 2
		InputManager.register(clickX, clickY, actualSize, actualSize, "path", targetId)

		-- Hover detection
		if
			mouseX >= clickX
			and mouseX <= clickX + actualSize
			and mouseY >= clickY
			and mouseY <= clickY + actualSize
		then
			hoveredPath = pathName
		end
		i = i + 1
		::continue::
	end -- Draw tooltip if hovering over an arrow
	if hoveredPath then
		local txt = "Go to " .. hoveredPath
		local tw = uiFontSmall:getWidth(txt)
		local th = uiFontSmall:getHeight()
		local boxW = tw + 12
		local boxH = th + 8
		local w, h = love.graphics.getDimensions()
		local margin = 10
		local tooltipX = math.min(math.max(mouseX + 20, margin), w - boxW - margin)
		local tooltipY = math.min(math.max(mouseY - th - 10, margin), h - boxH - margin)
		love.graphics.setColor(0, 0, 0, 0.7)
		love.graphics.rectangle("fill", tooltipX, tooltipY, boxW, boxH)
		love.graphics.setColor(1, 1, 1)
		love.graphics.print(txt, tooltipX + 6, tooltipY + 4)
	end
end

return SceneRenderer
