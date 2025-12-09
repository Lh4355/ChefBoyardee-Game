--[[
	File: src/system/interactions.lua
	Description: Handles item-specific interactions when the player uses
				 or interacts with items in the game world.
--]]

local Interactions = {}

local Utils = require("src.utils")

-- Define interaction functions by item ID
Interactions.items = {
	-- The Shop Attendant
	["attendant"] = function(player, currentNode, flags, selectedItemId)
		player:heal(100)
		player.skin = "gold"
		flags.has_gold_skin = true

		-- Remove the attendant from the room
		Utils.removeNodeItems(currentNode, { "attendant" })

		return true, "Attendant: 'You saved the shop! Let me fix that dent... and here, have a GOLD coating!'"
	end,

	["robber"] = function(player, currentNode, flags, selectedItemId)
		-- Player intervenes with robber: robber trips on the player
		player:takeDamage(15)
		flags.jewelry_robbery_done = true
		flags.jewelry_robbery_pending = false
		-- Remove robber from the room
		Utils.removeNodeItems(currentNode, { "robber" })
		-- Change the store image and description to resolved state
		currentNode.imagePath = "src/data/images/locations/jewelry_store.png"
		currentNode.description = "The robbers have been arrested and the woman is safe now."
		currentNode.image = Utils.loadImage(currentNode.imagePath)
		-- Add/update the attendant NPC immediately so sizing/position apply without re-entering node
		local attendant
		for _, it in ipairs(currentNode.items or {}) do
			if it.id == "attendant" then
				attendant = it
				break
			end
		end
		if not attendant then
			local Items = require("src.data.items")
			attendant = Utils.addItemToNode(currentNode, Items.attendant, { x = 262, y = 185, w = 160, h = 150 })
		else
			attendant.x = 262
			attendant.y = 185
			attendant.w = 160
			attendant.h = 150
		end

		return true, "CRASH! The robber trips and hits you for 15 damage. The police take him away."
	end,
	["dumpster_fire"] = function(player, currentNode, flags, selectedItemId)
		-- Requires the fire_extinguisher to be selected in inventory
		if selectedItemId ~= "fire_extinguisher" then
			return false, "The dumpster is on fire but you see something shiny in the flames."
		end

		-- Player uses fire extinguisher
		flags.dumpster_fire_extinguished = true

		-- Update the dumpster_fire node (node 31)
		currentNode.imagePath = "src/data/images/locations/dumpster.png"
		currentNode.description = "The dumpster is burnt."

		-- Reload the image from the new path
		currentNode.image = Utils.loadImage(currentNode.imagePath)

		-- Update sketchy_alley description (node 12)
		flags.sketchy_alley_needs_update = true

		-- Remove the dumpster_fire item from the scene
		Utils.removeNodeItems(currentNode, { "dumpster_fire" })

		-- Remove fire extinguisher from player inventory
		Utils.removeInventoryItems(player.inventory, { "fire_extinguisher" })

		-- Add a key item to the dumpster (use centralized definition)
		local Items = require("src.data.items")
		Utils.addItemToNode(currentNode, Items.dumpster_key, { x = 340, y = 240, w = 50, h = 50 })

		return true, "You put out the flames. The smoke clears, revealing a key in the dumpster!"
	end,

	["front_door"] = function(player, currentNode, flags, selectedItemId)
		-- This interaction requires the dumpster_key to be selected in inventory
		if selectedItemId ~= "dumpster_key" then
			return false, "The door is locked. You need to find a key to open it."
		end

		-- Player uses the key to unlock the door
		flags.front_door_unlocked = true

		-- Remove the front_door item from the scene (door is now unlocked/open)
		Utils.removeNodeItems(currentNode, { "front_door" })

		-- Remove dumpster_key from player inventory
		Utils.removeInventoryItems(player.inventory, { "dumpster_key" })

		return true, "You unlock the front door with the key and it swings open!"
	end,

	["recycling_bin"] = function(player, currentNode, flags, selectedItemId)
		return false, "There is a blue bin overflowing with tin cans, their skins removed. You feel sad."
	end,
}

-- Attempt to interact with an item by itemId
function Interactions.tryInteract(itemId, player, currentNode, flags, selectedItemId)
	local func = Interactions.items[itemId]
	if func then
		return func(player, currentNode, flags, selectedItemId)
	end

	-- No handler found: explicitly return false (handled=false)
	return false, nil
end

return Interactions
