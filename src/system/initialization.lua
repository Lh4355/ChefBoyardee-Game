-- src/system/initialization.lua
-- Handles all game initialization logic

local Node = require("src.entities.node")
local Item = require("src.entities.item")
local Player = require("src.entities.player")
local map_nodes_data = require("src.data.map_nodes")
local Constants = require("src.constants")
local Items = require("src.data.items")
local AudioManager = require("src.system.audio_manager")

-- Import States
local Menu = require("src.states.menu")

local Initialization = {}

--- Initialize all nodes with their data, images, items, and minigames
function Initialization.initializeNodes()
	local nodes = {}

	for id, data in pairs(map_nodes_data) do
		local newNode = Node.new(data.id, data.name or "Unnamed", data.description, data.imagePath)
		nodes[id] = newNode
		if data.imagePath then
			pcall(function()
				newNode.image = love.graphics.newImage(data.imagePath)
			end)
		end
		newNode.paths = data.paths -- Load paths
		newNode.arrows = data.arrows -- Load arrow positioning data
		newNode.items = newNode.items or {} -- Initialize items table

		-- Load items data from map_nodes if present
		if data.items then
			for _, itemData in ipairs(data.items) do
				local item
				if type(itemData) == "string" then
					-- Look up item from Items registry by ID
					local itemTemplate = Items[itemData]
					if itemTemplate then
						item = Item.new(
							itemTemplate.id,
							itemTemplate.name,
							itemTemplate.description,
							itemTemplate.spriteId,
							itemTemplate.canPickup
						)
					else
						print("Warning: Item '" .. itemData .. "' not found in Items registry")
					end
				else
					-- Handle inline item data (for backward compatibility)
					item = Item.new(itemData.id, itemData.name, itemData.description, itemData.spriteId)
				end

				if item then
					item.w = item.w or 50
					item.h = item.h or 50
					table.insert(newNode.items, item)
				end
			end
		end

		newNode.minigame = data.minigame -- Load minigame data if present
	end

	return nodes
end

--- Initialize the player
function Initialization.initializePlayer()
	return Player.new("Chef Can", 400, 300)
end

--- Initialize audio and play background music
function Initialization.initializeAudio()
	return AudioManager.initializeAudio()
end

return Initialization
