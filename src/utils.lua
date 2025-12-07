-- src/utils.lua
local Utils = {}

function Utils.checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
	return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

-- Update node image
function Utils.updateNodeImage(node, imagePath)
	node.imagePath = imagePath
	local success, img = pcall(love.graphics.newImage, imagePath)
	if success then
		node.image = img
	end
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
