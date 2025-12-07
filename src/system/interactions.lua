-- src/interactions.lua
local Interactions = {}

Interactions.items = {
	-- SPECIAL ITEM: The Shop Attendant
	["attendant"] = function(player, currentNode, flags)
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

		return "Attendant: 'You saved the shop! Let me fix that dent... and here, have a GOLD coating!'"
	end,

	["robber"] = function(player, currentNode, flags)
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
			local Item = require("src.entities.item")
			local attendant = Item.new("attendant", "Shop Attendant", "She looks grateful.", "attendant_sprite")
			attendant.x = 300
			attendant.y = 350
			attendant.w = 150
			table.insert(currentNode.items, attendant)
		end
		return "CRASH! The robber trips and hits you for 15 damage. The police take him away."
	end,

	-- You could add other items here later, e.g.:
	-- ["potion"] = function(player) ... end
}

function Interactions.tryInteract(itemId, player, currentNode, flags)
	local func = Interactions.items[itemId]
	if func then
		return true, func(player, currentNode, flags)
	end
	return false, nil
end

return Interactions
