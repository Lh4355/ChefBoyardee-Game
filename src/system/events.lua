--[[
	File: src/system/events.lua
	Description: Handles node-specific events and conditions for player entry.
	Each node can have a function that triggers on entry, affecting player state, flags, and node properties.
]]

local Items = require("src.data.items") -- Centralized item definitions
local Item = require("src.entities.item") -- Item class for instantiation
local Utils = require("src.utils") -- Utility functions (image loading, item helpers)

local Events = {}

-- Define events by Node ID

-- Table of event functions, keyed by node ID.
-- Each function is called when the player enters the corresponding node.
Events.nodes = {

	-- NODE 2: Aisle Floor (Fall Damage Event)
	-- Aisle Floor: First entry causes fall damage, subsequent entries do nothing.
	[2] = function(player, node, flags)
		if not flags.aisle_floor_visited then
			flags.aisle_floor_visited = true
			player:takeDamage(5) -- Deduct 5 health
			return true, "That fall hurt! You took 5 Damage."
		end
		return true, ""
	end,

	-- NODE 8: Scary Highway (risk of traffic damage)
	-- Scary Highway: Chance to take random damage from traffic each entry.
	[8] = function(player, node, flags)
		local dmgChance = 0.35 -- 35% per entry; adjust to taste
		if love.math.random() < dmgChance then
			local dmg = love.math.random(10, 25)
			player:takeDamage(dmg)
			return true, ("Traffic grazes you for %d damage!"):format(dmg)
		end
		return true, "You dodge the traffic and make it across."
	end,

	-- NODE 11: Steep Hill (tumble damage on descent)
	-- Steep Hill: Chance to tumble and take damage on descent.
	[11] = function(player, node, flags)
		local dmgChance = 0.18 -- 18% chance to tumble
		if love.math.random() < dmgChance then
			local dmg = love.math.random(3, 10)
			player:takeDamage(dmg)
			return true, ("You tumble down the hill for %d damage!"):format(dmg)
		end
		return true, "You keep your balance down the hill."
	end,

	-- NODE 5: Intersection 1 (robbery event trigger)
	-- Main Intersection: Handles robbery event messages if the
	[5] = function(player, node, flags)
		-- If robbery is pending, show the yelling message
		if flags.jewelry_robbery_pending and not flags.jewelry_robbery_done then
			return true, "You hear yelling coming from a shop nearby."
		end

		-- Only trigger once on the very first time the player enters intersection_1
		if not flags.intersection_1_seen then
			flags.intersection_1_seen = true
			-- Announce yelling and mark robbery as pending
			flags.jewelry_robbery_pending = true
			return true, "You hear yelling coming from a shop nearby."
		end
		return true, ""
	end,

	-- NODE 17: Jewelry Store (Robbery handling: pending, missed, or resolved)
	-- Jewelry Store: Handles robbery event, missed event, and peaceful state.
	[17] = function(player, node, flags)
		-- If the robbery was missed (player ignored the yelling), show empty shop
		if flags.jewelry_store_missed then
			node.imagePath = "src/data/images/locations/jewelry_store_empty.png"
			-- node.description = "The shelves of the jewlery shop are bare. and there is broken glass on the floor."
			node.image = Utils.loadImage(node.imagePath)
			return true, "The jewelry shop is empty."
		end

		-- If robbery is pending (player entered intersection and hasn't resolved yet)
		if flags.jewelry_robbery_pending and not flags.jewelry_robbery_done then
			node.imagePath = "src/data/images/locations/jewelry_store_robbery.png"
			node.image = Utils.loadImage(node.imagePath)
			-- Add a robber NPC if not already present; update position/size if it is
			local robber
			for _, it in ipairs(node.items or {}) do
				if it.id == "robber" then
					robber = it
					break
				end
			end
			if not robber then
				robber = Utils.addItemToNode(node, Items.robber, { x = 0, y = 115, w = 290, h = 500 })
			else
				robber.x = 0
				robber.y = 115
				robber.w = 290
				robber.h = 500
			end
			return true, "A robbery is happening at the jewelry store!"
		end

		-- If robbery already resolved, show the peaceful store and attendant (if needed)
		if flags.jewelry_robbery_done then
			node.imagePath = "src/data/images/locations/jewelry_store.png"
			node.description = "Glittering jewels and gold adorn the displays of the jewelry store. You can even see the reflection of you can on the floor. The attendant is happy."
			node.image = Utils.loadImage(node.imagePath)
			-- If the attendant (woman) hasn't given the player the gold skin yet, ensure she's present
			if not flags.has_gold_skin then
				local attendant
				for _, it in ipairs(node.items or {}) do
					if it.id == "attendant" then
						attendant = it
						break
					end
				end
				if not attendant then
					attendant = Utils.addItemToNode(node, Items.attendant, { x = 262, y = 185, w = 160, h = 150 })
				else
					attendant.x = 262
					attendant.y = 185
					attendant.w = 160
					attendant.h = 150
				end
			end
			return true, "The Jewelry Store is peaceful now."
		end

		-- Default: let them in
		return true, ""
	end,

	-- NODE 26: Living Room (requires front door to be unlocked only when entering from front porch)
	-- Living Room: Requires front door to be unlocked only when entering from front porch.
	[26] = function(player, node, flags, prevNode)
		if prevNode and prevNode.id == 23 and not flags.front_door_unlocked then
			return false, "You need to unlock the front door first."
		end
		return true, ""
	end,
}

--[[
	Checks if the player is allowed to enter a node, and triggers any node-specific events.
	Returns (allowed: bool, message: string). If no event is defined, always allows entry.
	Called by explore.lua when moving between nodes.
]]
function Events.checkEnter(node, player, flags, prevNode)
	-- Use node.id to find the event
	local eventFunc = Events.nodes[node.id]

	if eventFunc then
		-- Pass the REAL node object (which has the .items table) and previous node
		return eventFunc(player, node, flags, prevNode)
	end

	-- Default: No event, player can enter
	return true, ""
end

return Events
