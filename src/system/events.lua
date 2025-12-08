-- src/events.lua
local Items = require("src.data.items")

local Events = {}

-- Helper to set the message shown on screen
local function setMessage(msg)
	return msg
end

-- Define events by Node ID
Events.nodes = {

	-- NODE 2: Aisle Floor (Fall Damage Event)
	[2] = function(player, node, flags)
		if not flags.aisle_floor_visited then
			flags.aisle_floor_visited = true
			player:takeDamage(5) -- Deduct 5 health
			return true, "That fall hurt! You took 5 Damage."
		end
		return true, ""
	end,

	-- NODE 8: Scary Highway (risk of traffic damage)
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
	[11] = function(player, node, flags)
		local dmgChance = 0.18 -- 18% chance to tumble
		if love.math.random() < dmgChance then
			local dmg = love.math.random(3, 10)
			player:takeDamage(dmg)
			return true, ("You tumble down the hill for %d damage!"):format(dmg)
		end
		return true, "You keep your balance down the hill."
	end,

	-- NODE 5: Intersection 1 (first-visit yelling triggers pending robbery)
	[5] = function(player, node, flags)
		-- If robbery is pending, show the yelling message
		if flags.jewelry_robbery_pending and not flags.jewelry_robbery_done then
			return true, "You hear yelling coming from a shop nearby."
		end
		-- If robbery was missed/concluded, intersection is quiet
		if flags.jewelry_robbery_done or flags.jewelry_store_missed then
			return true, "The intersection is quiet."
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
	[17] = function(player, node, flags)
		-- If the robbery was missed (player ignored the yelling), show empty shop
		if flags.jewelry_store_missed then
			node.imagePath = "src/data/images/locations/jewelry_store_empty.png"
			node.description = "The jewelry shop is empty."
			-- Reload the image from the new path
			local success, img = pcall(love.graphics.newImage, node.imagePath)
			if success then
				node.image = img
			end
			return true, "The jewelry shop is empty."
		end

		-- If robbery is pending (player entered intersection and hasn't resolved yet)
		if flags.jewelry_robbery_pending and not flags.jewelry_robbery_done then
			-- Ensure the robbery image is shown
			node.imagePath = "src/data/images/locations/jewelry_store_robbery.png"
			-- Reload the image from the new path
			local success, img = pcall(love.graphics.newImage, node.imagePath)
			if success then
				node.image = img
			end
			-- Add a robber NPC if not already present
			local hasRobber = false
			for _, it in ipairs(node.items or {}) do
				if it.id == "robber" then
					hasRobber = true
					break
				end
			end
			if not hasRobber then
				local robber = Items.robber
				robber.x = 320
				robber.y = 220
				robber.w = 120
				table.insert(node.items, robber)
			end
			return true, "A robbery is happening at the jewelry store!"
		end

		-- If robbery already resolved, show the peaceful store and attendant if needed
		if flags.jewelry_robbery_done then
			node.imagePath = "src/data/images/locations/jewelry_store.png"
			node.description = "The robbers have been arrested and the woman is safe now."
			-- Reload the image from the new path
			local success, img = pcall(love.graphics.newImage, node.imagePath)
			if success then
				node.image = img
			end
			-- If the attendant (woman) hasn't given the player the gold skin yet, ensure she's present
			if not flags.has_gold_skin then
				local hasAttendant = false
				for _, it in ipairs(node.items or {}) do
					if it.id == "attendant" then
						hasAttendant = true
						break
					end
				end
				if not hasAttendant then
					local attendant = Items.attendant
					attendant.x = 300
					attendant.y = 350
					attendant.w = 150
					table.insert(node.items, attendant)
				end
			end
			return true, "The Jewelry Store is peaceful now."
		end

		-- Default: let them in
		return true, ""
	end,

	-- NODE 23: Front Porch (allows access to living_room once door is unlocked)
	[23] = function(player, node, flags)
		-- Check if fire has been extinguished
		if flags.dumpster_fire_extinguished then
			return true, "The front porch is quiet."
		end
		return true, ""
	end,

	-- NODE 26: Living Room (requires front door to be unlocked only when entering from front porch)
	[26] = function(player, node, flags, prevNode)
		-- Only require front door to be unlocked when coming from the front porch (node 23)
		if prevNode and prevNode.id == 23 and not flags.front_door_unlocked then
			return false, "You need to unlock the front door first."
		end
		return true, ""
	end,
}

-- The function Main.lua will actually call
function Events.checkEnter(node, player, flags, prevNode)
	-- Use node.id to find the event
	local eventFunc = Events.nodes[node.id]

	if eventFunc then
		-- Pass the REAL node object (which has the .items table) and previous node
		return eventFunc(player, node, flags, prevNode)
	end

	-- Default: No event, just let them in
	return true, ""
end

return Events
