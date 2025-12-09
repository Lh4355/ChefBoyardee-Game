--[[
	File: /src/entities/player.lua
	Description: Player entity (class) definition and methods
--]]

local Player = {}
Player.__index = Player

-- Function to create a new Player instance
function Player.new(name, x, y)
	local instance = setmetatable({}, Player)
	instance.name = name
	instance.x = x
	instance.y = y
	instance.health = 100
	instance.inventory = {}
	instance.skin = "tin"
	instance.visitedNodes = {}
	return instance
end

-- Check if player has an item by ID
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

-- Handle taking damage
function Player:takeDamage(amount)
	self.health = self.health - amount
	if self.health < 0 then
		self.health = 0
	end
	print("Player took " .. amount .. " damage! Health is now: " .. self.health)
end

-- Handle healing
function Player:heal(amount)
	self.health = self.health + amount
	if self.health > 100 then
		self.health = 100
	end
	print("Player healed " .. amount .. ". Health is now: " .. self.health)
end

-- Check if player has visited a node by ID
function Player:hasVisited(nodeId)
	for _, id in ipairs(self.visitedNodes) do
		if id == nodeId then
			return true
		end
	end
	return false
end

-- Mark a node as visited
function Player:visitNode(nodeId)
	-- check that nodeID exists
	if not nodeId then
		return
	end
	-- if not already visited, add to visitedNodes
	if not self:hasVisited(nodeId) then
		table.insert(self.visitedNodes, nodeId)
	end
end

return Player
