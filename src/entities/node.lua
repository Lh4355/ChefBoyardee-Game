--[[
	File: /src/entities/node.lua
	Description: Node entity (class) definition
--]]


local Node = {}
Node.__index = Node

-- Function to create a new Node instance
function Node.new(id, name, description, imagePath)
	local instance = setmetatable({}, Node)

	instance.id = id 
	instance.name = name 
	instance.description = description 
	instance.imagePath = imagePath
	instance.paths = {}
	instance.items = {}

	return instance
end

return Node
