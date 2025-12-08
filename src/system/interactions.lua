-- src/interactions.lua
local Interactions = {}

Interactions.items = {
	-- SPECIAL ITEM: The Shop Attendant
	["attendant"] = function(player, currentNode, flags, selectedItemId)
		player:heal(100)
		player.skin = "gold"
		flags.has_gold_skin = true

		-- Remove the attendant from the room
		for i, item in ipairs(currentNode.items) do
			if item.id == "attendant" then
				table.remove(currentNode.items, i)
				break
			end
		end

		return true, "Attendant: 'You saved the shop! Let me fix that dent... and here, have a GOLD coating!'"
	end,

	["robber"] = function(player, currentNode, flags, selectedItemId)
		-- Player intervenes with robber: robber trips on the player
		player:takeDamage(15)
		flags.jewelry_robbery_done = true
		flags.jewelry_robbery_pending = false
		-- Remove robber from the room
		for i, item in ipairs(currentNode.items) do
			if item.id == "robber" then
				table.remove(currentNode.items, i)
				break
			end
		end
		-- Change the store image and description to resolved state
		currentNode.imagePath = "src/data/images/locations/jewelry_store.png"
		currentNode.description = "The robbers have been arrested and the woman is safe now."
		-- Reload the image from the new path
		local success, img = pcall(love.graphics.newImage, currentNode.imagePath)
		if success then
			currentNode.image = img
		end
		-- Add the attendant NPC so player may be healed/gifted
		local hasAttendant = false
		for _, it in ipairs(currentNode.items or {}) do
			if it.id == "attendant" then
				hasAttendant = true
				break
			end
		end
		if not hasAttendant then
			local Items = require("src.data.items")
			local attendant = Items.attendant
			attendant.x = 300
			attendant.y = 350
			attendant.w = 150
			table.insert(currentNode.items, attendant)
		end
		return true, "CRASH! The robber trips and hits you for 15 damage. The police take him away."
	end,
	["dumpster_fire"] = function(player, currentNode, flags, selectedItemId)
		-- This interaction requires the fire_extinguisher to be selected in inventory
		if selectedItemId ~= "fire_extinguisher" then
			return false, "The dumpster is on fire but you see something shiny in the flames."
		end

		-- Player uses fire extinguisher
		flags.dumpster_fire_extinguished = true

		-- Update the dumpster_fire node (node 31)
		currentNode.imagePath = "src/data/images/locations/dumpster.png"
		currentNode.description = "The dumpster is burnt."

		-- Reload the image from the new path
		local success, img = pcall(love.graphics.newImage, currentNode.imagePath)
		if success then
			currentNode.image = img
		end

		-- Update sketchy_alley description (node 12)
		flags.sketchy_alley_needs_update = true

		-- Remove the dumpster_fire item from the scene
		for i, item in ipairs(currentNode.items) do
			if item.id == "dumpster_fire" then
				table.remove(currentNode.items, i)
				break
			end
		end

		-- Remove fire extinguisher from player inventory
		for i, item in ipairs(player.inventory) do
			if item.id == "fire_extinguisher" then
				table.remove(player.inventory, i)
				break
			end
		end

		-- Add a key item to the dumpster (use centralized definition)
		local Items = require("src.data.items")
		local key = Items.dumpster_key
		key.w = 50
		key.h = 50
		table.insert(currentNode.items, key)

		return true,
			"You spray the fire extinguisher on the dumpster and put out the flames. As the smoke clears, you spot a key in the dumpster!"
	end,

	["front_door"] = function(player, currentNode, flags, selectedItemId)
		-- This interaction requires the dumpster_key to be selected in inventory
		if selectedItemId ~= "dumpster_key" then
			return false, "The door is locked. You need to find a key to open it."
		end

		-- Player uses the key to unlock the door
		flags.front_door_unlocked = true

		-- Remove the front_door item from the scene (door is now unlocked/open)
		for i, item in ipairs(currentNode.items) do
			if item.id == "front_door" then
				table.remove(currentNode.items, i)
				break
			end
		end

		-- Remove dumpster_key from player inventory
		for i, item in ipairs(player.inventory) do
			if item.id == "dumpster_key" then
				table.remove(player.inventory, i)
				break
			end
		end

		return true, "You unlock the front door with the key and it swings open!"
	end,

	["recycling_bin"] = function(player, currentNode, flags, selectedItemId)
		return false, "There is a blue bin overflowing with tin cans, their skins removed. You feel sad."
	end,

	-- You could add other items here later, e.g.:
	-- ["potion"] = function(player) ... end
}

function Interactions.tryInteract(itemId, player, currentNode, flags, selectedItemId)
	local func = Interactions.items[itemId]
	if func then
		return func(player, currentNode, flags, selectedItemId)
	end

	-- No handler found: explicitly return false (handled=false)
	return false, nil
end

return Interactions
