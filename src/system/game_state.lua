--[[
	File: src/system/game_state.lua
	Description: Manages game state flags and handles state transitions.
--]]

local GameState = {}
GameState.__index = GameState

-- Node constants
local NODE_JEWELRY_STORE = 17
local NODE_SKETCHY_ALLEY = 12
local NODE_START = 1

-- Utility module
local Utils = require("src.utils")

-- Initialize all game flags
function GameState.new()
	local self = {
		jewelry_robbery_done = false,
		has_gold_skin = false,
		jewelry_robbery_pending = false,
		jewelry_store_missed = false,
		sketchy_alley_needs_update = false,
		front_door_unlocked = false,
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
	if not player:hasVisited(NODE_JEWELRY_STORE) then
		self:setFlag("jewelry_store_missed", true)
		self:setFlag("jewelry_robbery_done", true)
		self:setFlag("jewelry_robbery_pending", false)

		-- Update jewelry store node
		if nodes[NODE_JEWELRY_STORE] then
			Utils.updateNodeImage(nodes[NODE_JEWELRY_STORE], "src/data/images/locations/jewelry_store_empty.png")
			Utils.removeNodeItems(nodes[NODE_JEWELRY_STORE], { "robber", "attendant" })
		end
	end
end

-- Handle sketchy alley fire extinguishment
function GameState:handleSketchyAlleyUpdate(nodes)
	if self.sketchy_alley_needs_update and nodes[NODE_SKETCHY_ALLEY] then
		Utils.updateNodeDescription(
			nodes[NODE_SKETCHY_ALLEY],
			"This alley looks like bad news. And it's suddenly nighttime. At least it isn't as smokey."
		)
		self:setFlag("sketchy_alley_needs_update", false)
	end
end

-- Reset all game state for a fresh playthrough
function GameState:reset(player, nodes)
	-- Reset all flags to defaults
	local defaultState = GameState.new()
	for key, value in pairs(defaultState) do
		self[key] = value
	end

	-- Reset player
	player.health = 100
	player.skin = "tin"
	player.inventory = {}
	player.visitedNodes = {}

	-- Reinitialize nodes
	local Initialization = require("src.system.initialization")
	local newNodes = Initialization.initializeNodes()
	for id, node in pairs(newNodes) do
		nodes[id] = node
	end
end

-- State switching function
function GameState.switchState(currentState, newState, player, nodes)
	-- Pass shared data (player, nodes) to the state if it needs it
	if newState.enter then
		newState.enter(player, nodes, nodes[NODE_START])
	end
	return newState
end

return GameState
