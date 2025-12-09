--[[
	File: /src/entities/item.lua
	Description: Item entity (class) definition
--]]

local Item = {}
Item.__index = Item

-- Function to create a new Item instance
function Item.new(id, name, description, spriteId, canPickup)
	local instance = setmetatable({}, Item)

	instance.id = id 
	instance.name = name 
	instance.description = description
	instance.spriteId = spriteId 
	instance.canPickup = canPickup ~= false

	return instance
end

return Item
