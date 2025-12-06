-- src/item.lua
local Item = {}
Item.__index = Item

-- Create a new Item instance
-- spriteId will eventually be the image name, e.g., "key_sprite"
function Item.new(id, name, description, spriteId)
    local instance = setmetatable({}, Item)
    
    instance.id = id                    -- Unique ID (e.g., "gum", "key")
    instance.name = name                -- Display name (e.g., "Chewed Gum")
    instance.description = description  -- Text shown when inspecting
    instance.spriteId = spriteId        -- Placeholder for the art asset
    
    return instance
end

return Item