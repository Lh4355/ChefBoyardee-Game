--[[
	File: src/data/items.lua
	Description: Definitions for items used across multiple nodes.
-- ]]

local Item = require("src.entities.item")

local Items = {}

Items.attendant = Item.new("attendant", "Shop Attendant", "She looks grateful.", "attendant_sprite")
Items.dumpster_key =
	Item.new("dumpster_key", "Dumpster Key", "A grimy dumpster key. What does it unlock?", "key_sprite")

-- Additional centralized items used across the game
Items.robber = Item.new("robber", "Robber", "A masked robber. Click to intervene!", "robber_sprite")

Items.fire_extinguisher = Item.new(
	"fire_extinguisher",
	"Fire Extinguisher",
	"A red fire extinguisher. Could be useful.",
	"fire_extinguisher_sprite",
	true -- Can be picked up
)
Items.recycling_bin = Item.new(
	"recycling_bin",
	"Recycling Bin",
	"A blue bin overflowing with tin cans.",
	"recycling_bin_sprite",
	false -- Cannot be picked up (interaction only)
)
Items.dumpster_fire = Item.new(
	"dumpster_fire",
	"Dumpster Fire",
	"A dumpster engulfed in flames.",
	"dumpster_fire_sprite",
	false -- Cannot be picked up (interaction only)
)
Items.front_door = Item.new(
	"front_door",
	"Lock",
	"A locked front door.",
	"lock_sprite",
	false -- Cannot be picked up (interaction only)
)

return Items
