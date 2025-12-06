-- src/player.lua
local Player = {}
Player.__index = Player

function Player.new(name, x, y)
	local instance = setmetatable({}, Player)
	instance.name = name
	instance.x = x
	instance.y = y
	instance.health = 100
	instance.inventory = {}
	instance.skin = "tin"
	return instance
end

-- Check if player has a specific item by ID
function Player:hasItem(itemId)
	for _, item in ipairs(self.inventory) do
		if item.id == itemId then
			return true
		end
	end
	return false
end

-- Attempt to add item to inventory
-- Returns true if successful, false if inventory is full
function Player:addItem(item)
	if #self.inventory < 8 then
		table.insert(self.inventory, item)
		return true
	end
	return false
end

-- Handle taking damage (Day 4 & "Dented" Mechanic)
function Player:takeDamage(amount)
	self.health = self.health - amount
	if self.health < 0 then
		self.health = 0
	end
	print("Player took " .. amount .. " damage! Health is now: " .. self.health)

	-- FUTURE TODO: Add code here to change sprite based on health
	-- e.g., if self.health < 50 then self.sprite = dented_sprite end
end

-- Handle healing (For "Polish" or "Tape" items)
function Player:heal(amount)
	self.health = self.health + amount
	if self.health > 100 then
		self.health = 100
	end
	print("Player healed " .. amount .. ". Health is now: " .. self.health)
end

return Player
