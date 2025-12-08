-- src/item.lua
local Item = {}
Item.__index = Item

-- Create a new Item instance
-- spriteId will eventually be the image name, e.g., "key_sprite"
-- canPickup (optional) determines if item can be added to inventory (default: true)
function Item.new(id, name, description, spriteId, canPickup)
	local instance = setmetatable({}, Item)

	instance.id = id -- Unique ID (e.g., "gum", "key")
	instance.name = name -- Display name (e.g., "Chewed Gum")
	instance.description = description -- Text shown when inspecting
	instance.spriteId = spriteId -- Placeholder for the art asset
	instance.canPickup = canPickup ~= false -- Default to true unless explicitly false

	return instance
end

return Item
