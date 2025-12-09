-- src/utils.lua
local Utils = {}

function Utils.checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
	return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

-- Load a font safely with pcall
-- Returns the font object on success, or a default font on failure
function Utils.loadFont(fontPath, fontSize)
	local size = fontSize or 12
	if fontPath then
		local success, font = pcall(love.graphics.newFont, fontPath, size)
		if success then
			return font
		end
	end
	-- Fallback to default font at requested size
	return love.graphics.newFont(size)
end

-- Load an image safely with pcall
-- Returns the image object on success, or false on failure (sentinel to avoid retries)
function Utils.loadImage(imagePath)
	local success, img = pcall(love.graphics.newImage, imagePath)
	if success then
		return img
	else
		return false
	end
end

-- Update node image
function Utils.updateNodeImage(node, imagePath)
	node.imagePath = imagePath
	node.image = Utils.loadImage(imagePath)
end

-- Update node description
function Utils.updateNodeDescription(node, description)
	node.description = description
end

-- Remove items from node by itemIds table
function Utils.removeNodeItems(node, itemIds)
	if not node.items then
		return
	end
	local newItems = {}
	for _, it in ipairs(node.items) do
		local remove = false
		for _, id in ipairs(itemIds) do
			if it.id == id then
				remove = true
				break
			end
		end
		if not remove then
			table.insert(newItems, it)
		end
	end
	node.items = newItems
end

return Utils
