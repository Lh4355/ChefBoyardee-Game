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
	"fire_extinguisher_sprite"
)

return Items
