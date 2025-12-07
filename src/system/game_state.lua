-- src/system/game_state.lua
-- Encapsulates game flags and state management
local GameState = {}
GameState.__index = GameState

-- Initialize all game flags
function GameState.new()
	local self = {
		jewelry_robbery_done = false,
		has_gold_skin = false,
		jewelry_robbery_pending = false,
		jewelry_store_missed = false,
		sketchy_alley_needs_update = false,
	}
	return setmetatable(self, GameState)
end

-- Check if a flag is set
function GameState:getFlag(flagName)
	return self[flagName] or false
end

-- Set a flag
function GameState:setFlag(flagName, value)
	self[flagName] = value
end

-- Handle jewelry store logic when player misses the robbery
function GameState:handleMissedJewelryRobbery(nodes, player)
	if not self.jewelry_robbery_pending then
		return
	end

	-- If player hasn't visited jewelry store yet, they missed the robbery
	if not player:hasVisited(17) then
		self:setFlag("jewelry_store_missed", true)
		self:setFlag("jewelry_robbery_done", true)
		self:setFlag("jewelry_robbery_pending", false)

		-- Update jewelry store node
		if nodes[17] then
			local Utils = require("src.utils")
			Utils.updateNodeImage(nodes[17], "src/data/images/locations/jewelry_store_empty.png")
			Utils.updateNodeDescription(nodes[17], "The jewelry shop is empty.")
			Utils.removeNodeItems(nodes[17], { "robber", "attendant" })
		end
	end
end

-- Handle sketchy alley fire extinguishment
function GameState:handleSketchyAlleyUpdate(nodes)
	if self.sketchy_alley_needs_update and nodes[12] then
		local Utils = require("src.utils")
		Utils.updateNodeDescription(nodes[12], "It is a sketchy alley.")
		self:setFlag("sketchy_alley_needs_update", false)
	end
end

return GameState
