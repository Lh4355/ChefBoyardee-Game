-- src/node.lua
local Node = {}
Node.__index = Node

-- This function creates a new Node instance
function Node.new(id, name, description, imagePath)
	local instance = setmetatable({}, Node)

	instance.id = id -- Unique ID (e.g., 1, 2, "start")
	instance.name = name -- Name of node
	instance.description = description -- Text shown to the player
	instance.imagePath = imagePath -- Path to the background image
	instance.paths = {} -- Stores connections (e.g., {north = 2})
	instance.items = {} -- Items available in this location

	return instance
end

return Node
