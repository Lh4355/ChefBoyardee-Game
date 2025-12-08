-- src/data/items.lua
local Item = require("src.entities.item")

local Items = {}

Items.attendant = Item.new("attendant", "Shop Attendant", "She looks grateful.", "attendant_sprite")
Items.dumpster_key =
	Item.new("dumpster_key", "Dumpster Key", "A key found in the dumpster. It might open something.", "key_sprite")

-- Additional centralized items used across the game
Items.robber = Item.new("robber", "Robber", "A masked robber. Click to intervene!", "robber_sprite")
Items.fire_extinguisher = Item.new(
	"fire_extinguisher",
	"Fire Extinguisher",
	"A red fire extinguisher. You can use it to put out fires.",
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
	"Front Door",
	"A locked front door.",
	"front_door_sprite",
	false -- Cannot be picked up (interaction only)
)

return Items
