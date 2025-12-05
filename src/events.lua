-- src/events.lua
local Item = require("src.item")

local Events = {}

-- Helper to set the message shown on screen
local function setMessage(msg)
	return msg
end

-- Define events by Node ID
Events.nodes = {
	-- NODE 8: Scary Highway (Locked Path Example)
	[8] = function(player, node, flags)
		if not player:hasItem("rusty_key") then
			return false, "LOCKED: You need a Rusty Key to enter the Scary Highway!"
		end
		return true, "" -- Access Granted
	end,

	-- NODE 17: Jewelry Store (Robbery Event)
	[17] = function(player, node, flags)
		if not flags.jewelry_robbery_done then
			flags.jewelry_robbery_done = true
			player:takeDamage(20)

			-- Add the Attendant NPC dynamically
			local attendant = Item.new("attendant", "Talk to Attendant", "She looks grateful.", "npc_sprite")
			attendant.x = 300
			attendant.y = 350
			attendant.w = 150
			table.insert(node.items, attendant)

			return true, "CRASH! A robber trips over you! You took 20 Damage. The police grab him."
		else
			return true, "The Jewelry Store is peaceful now."
		end
	end,
}

-- The function Main.lua will actually call
function Events.checkEnter(node, player, flags)
    -- Use node.id to find the event
    local eventFunc = Events.nodes[node.id]
    
    if eventFunc then
        -- Pass the REAL node object (which has the .items table)
        return eventFunc(player, node, flags)
    end
    
    -- Default: No event, just let them in
    return true, ""
end

return Events
