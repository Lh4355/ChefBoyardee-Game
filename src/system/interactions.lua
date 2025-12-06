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
