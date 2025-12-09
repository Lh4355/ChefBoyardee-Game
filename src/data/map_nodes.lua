-- src/data/map_nodes.lua
-- This file returns a list of raw data tables.
-- We use this data in main.lua to build our actual Node objects.

-- FIXME: Add accurate descriptions
-- FIXME: Map nodes on paper to make sure they connect correctly
-- FIXME: Did i link them all correctly

return {
	-- NODE 1: The Starting Area/Shelf
	-- FIXME: Should the the person coming to look at them be an event?
	-- FIXME: Should falling off the shelf be an event?
	[1] = {
		id = 1,
		name = "shelf",
		description = "The cold metal of the cans surrounding you gives you a sense of determination. You must escape this shelf!",
		imagePath = "src/data/images/locations/shelf.png",
		paths = {},

		minigame = {
			type = "click_filler",
			imagePath = "src/data/images/sprites/angled_can.png",

			-- Position & Sprite
			x = 448,
			y = 283,
			scale = 0.35,

			-- Gameplay
			decay = 25,
			add = 15,
			max = 100,
			winNode = 2,
			winMsg = "You wobble off the shelf!",

			-- New Visual Customization --
			prompt = "WOBBLE!",

			-- 1. Bar Dimensions & Position
			barWidth = 100,
			barHeight = 15,
			barX = 401,
			barY = 382,

			-- 2. Colors (R, G, B, A)
			barColor = { 1, 0.84, 0, 1 }, -- Gold fill
			barBgColor = { 0.2, 0.2, 0.2, 0.8 }, -- Dark Grey background
			borderColor = { 1, 1, 1, 1 }, -- White border
			borderWidth = 2,
			textColor = { 1, 1, 1, 1 }, -- White text

			-- 3. Font Customization
			fontPath = "src/data/fonts/friz-quadrata-regular.ttf",
			fontSize = 15,

			-- 4. Feel (Shake)
			shakeIntensity = 0.2, -- Higher number = more violent shake
			shakeSpeed = 30, -- Higher number = faster vibration
		},
	},

	-- NODE 2: The Aisle Floor
	[2] = {
		id = 2,
		name = "aisle_floor",
		description = "You leap off the shelf. The tiles are cold under your ridges.",
		imagePath = "src/data/images/locations/aisle_floor.png",
		paths = {
			outside_store = 3,
		},
		arrows = {
			outside_store = { x = 380, y = 375, rotation = 3 * math.pi / 2, scale = 1 },
		},
	},

	-- NODE 3: Outside Front of Grocery Store
	[3] = {
		id = 3,
		name = "outside_store",
		description = "The sun blinds you as you exit the grocery store. The city feels alive with noise and movement.",
		imagePath = "src/data/images/locations/outside_store.png",
		paths = {
			intersection_1 = 5,
			aisle_floor = 2,
		},
		arrows = {
			intersection_1 = { x = 75, y = 385, rotation = math.pi, scale = 1 },
			aisle_floor = { x = 550, y = 400, rotation = math.pi, scale = 1 },
		},
	},

	-- -- NODE 4: Road 1
	-- -- FIXME: maybe add a sewer grate
	-- [4] = {
	-- 	id = 4,
	-- 	name = "road_1",
	-- 	description = "Road 1 (Outside Grocery Store)",
	-- 	imagePath = nil,
	-- 	paths = {
	-- 		intersection_1 = 5,
	-- 		outside_store = 3,
	-- 	},
	-- },

	-- NODE 5: Main Intersection
	[5] = {
		id = 5,
		name = "intersection_1",
		description = "Intersection 1 (main one)",
		imagePath = "src/data/images/locations/intersection_1.png",
		paths = {
			outside_store = 3,
			jewelry_store = 17,
			scary_highway = 8,
		},
		arrows = {
			outside_store = { x = 25, y = 400, rotation = math.pi, scale = 1 },
			jewelry_store = { x = 200, y = 400, rotation = 3 * math.pi / 2, scale = 1 },
			scary_highway = { x = 600, y = 200, rotation = 3 * math.pi / 2, scale = 1 },
		},
	},

	-- -- NODE 7: Road 2
	-- [6] = {
	-- 	id = 6,
	-- 	name = "road_2",
	-- 	description = "Road 2 (goes to shops)",
	-- 	imagePath = nil,
	-- 	paths = {
	-- 		shops = 16,
	-- 		intersection_1 = 5,
	-- 	},
	-- },

	-- -- NODE 7: Road 3
	-- [7] = {
	-- 	id = 7,
	-- 	name = "road_3",
	-- 	description = "Road 3 (goes to cannery and gravel path)",
	-- 	imagePath = nil,
	-- 	paths = {
	-- 		intersection_1 = 5,
	-- 		gravel_path = 9,
	-- 		cannery = 18,
	-- 		intersection_2 = 15,
	-- 	},
	-- },

	-- NODE 8: Scary Highway
	[8] = {
		id = 8,
		name = "scary_highway",
		description = "Scary, busy highway (goes to sketchy alley or steep downhill)",
		imagePath = "src/data/images/locations/scary_highway.png",
		paths = {
			intersection_1 = 5,
			steep_hill = 11,
			sketchy_alley = 12,
		},
		arrows = {
			intersection_1 = { x = 75, y = 400, rotation = math.pi / 2, scale = 1 },
			steep_hill = { x = 590, y = 150, rotation = math.pi, scale = 1 },
			sketchy_alley = { x = 230, y = 150, rotation = 3 * math.pi / 2, scale = 1 },
		},
	},

	-- -- NODE 9: Gravel Path
	-- -- FIXME: add event to take health away if the can takes the gravel path
	-- [9] = {
	-- 	id = 9,
	-- 	name = "gravel_path",
	-- 	description = "Gravel Path (from Road 2-> Neighborhood street)",
	-- 	imagePath = "src/data/images/locations/gravel_path.png",
	-- 	paths = {
	-- 		neighborhood_street = 10,
	-- 		road_3 = 7,
	-- 		movers_house = 32,
	-- 	},
	-- },

	-- NODE 10: Neighborhood Street
	[10] = {
		id = 10,
		name = "neighborhood_street",
		description = "Neighborhood Street",
		imagePath = "src/data/images/locations/neighborhood_street.png",
		paths = {
			-- gravel_path = 9,
			steep_hill = 11,
			-- recycling_house = 33,
			-- movers_house = 32,
			outside_house = 21,
		},

		items = {
			{ id = "fire_extinguisher", x = 55, y = 205, w = 30, h = 60 },
			{ id = "recycling_bin", x = 220, y = 380, w = 80, h = 80 },
		},
		arrows = {
			steep_hill = { x = 50, y = 480, rotation = math.pi / 2, scale = 1 },
			outside_house = { x = 700, y = 400, rotation = 3 * math.pi / 2, scale = 1 },
		},
	},

	-- NODE 11: Steep Hill
	[11] = {
		id = 11,
		name = "steep_hill",
		description = "Steep Hill (connects scary_highway to neighborhood_street)",
		imagePath = "src/data/images/locations/steep_hill.png",
		paths = {
			neighborhood_street = 10,
			scary_highway = 8,
		},
		arrows = {
			neighborhood_street = { x = 100, y = 450, rotation = math.pi / 2, scale = 1 },
			scary_highway = { x = 700, y = 380, rotation = 3 * math.pi / 2, scale = 1 },
		},
	},

	-- NODE 12: Sketchy Alley
	-- FIXME: add counterfiet soup seller --> should this be an event/encounter instead of a location and event/encounter
	-- FIXME: maybe a sewer shortcut
	[12] = {
		id = 12,
		name = "sketchy_alley",
		description = "You smell something burning...",
		imagePath = "src/data/images/locations/sketchy_alley.png",
		paths = {
			scary_highway = 8,
			dumpster_fire = 31,
		},
		arrows = {
			scary_highway = { x = 50, y = 450, rotation = math.pi / 2, scale = 1 },
			dumpster_fire = { x = 450, y = 300, rotation = 3 * math.pi / 2, scale = 1 },
		},
	},

	-- -- NODE 13: Road 4
	-- [13] = {
	-- 	id = 13,
	-- 	name = "road_4",
	-- 	description = "Road 4",
	-- 	imagePath = nil,
	-- 	paths = {
	-- 		dump = 19,
	-- 		park = 22,
	-- 	},
	-- },

	-- -- NODE 14: Road 5
	-- [14] = {
	-- 	id = 14,
	-- 	name = "road_5",
	-- 	description = "Road 5",
	-- 	imagePath = nil,
	-- 	paths = {
	-- 		intersection_2 = 15,
	-- 		dump = 19,
	-- 		cannery = 18,
	-- 	},
	-- },

	-- -- NODE 15: Intersection 2
	-- [15] = {
	-- 	id = 15,
	-- 	name = "intersection_2",
	-- 	description = "Intersection 2",
	-- 	imagePath = nil,
	-- 	paths = {
	-- 		road_3 = 7,
	-- 		road_4 = 13,
	-- 		road_5 = 14,
	-- 	},
	-- },

	-- -- NODE 16: Shops
	-- -- FIXME: potentially add more shops
	-- [16] = {
	-- 	id = 16,
	-- 	name = "shops",
	-- 	description = "Various Shops",
	-- 	imagePath = nil,
	-- 	paths = {
	-- 		jewelry_store = 17,
	-- 		road_2 = 6,
	-- 	},
	-- },

	-- NODE 17: Jewelry Store
	-- FIXME: when player goes here, a robbery will be happening, if can enters store the robber will trip on them and dent the can
	-- FIXME: player gets gold can skin for helping (does it fix any dents?)
	-- FIXME: change jewelry store image to change before during and after event
	[17] = {
		id = 17,
		name = "jewelry_store",
		description = "Jewelry Store",
		imagePath = "src/data/images/locations/jewelry_store_robbery.png",
		paths = {
			-- shops = 16,
			intersection_1 = 5,
		},
		arrows = {
			intersection_1 = { x = 400, y = 450, rotation = math.pi / 2, scale = 1 },
		},
	},

	-- -- NODE 18: Cannery
	-- -- FIXME: visiting Cannery increases health/new label?
	-- [18] = {
	-- 	id = 18,
	-- 	name = "cannery",
	-- 	description = "Cannery",
	-- 	imagePath = nil,
	-- 	paths = {
	-- 		road_3 = 7,
	-- 		road_5 = 14,
	-- 	},
	-- },

	-- -- NODE 19: Dump
	-- [19] = {
	-- 	id = 19,
	-- 	name = "dump",
	-- 	description = "Dump",
	-- 	imagePath = nil,
	-- 	paths = {
	-- 		road_4 = 13,
	-- 		road_5 = 14,
	-- 		recycling_truck = 20,
	-- 	},
	-- },

	-- -- NODE 20: Recycling Truck
	-- [20] = {
	-- 	id = 20,
	-- 	name = "recycling_truck",
	-- 	description = "Recycling truck",
	-- 	imagePath = nil,
	-- 	paths = {
	-- 		neighborhood_street = 10,
	-- 		outside_house = 21,
	-- 	},
	-- },

	-- NODE 21: Outside of House
	[21] = {
		id = 21,
		name = "outside_house",
		description = "Outside of House",
		imagePath = "src/data/images/locations/outside_house.png",
		paths = {
			-- park = 22,
			neighborhood_street = 10,
			front_porch = 23,
			backyard = 24,
		},
		arrows = {
			neighborhood_street = { x = 100, y = 450, rotation = math.pi / 2, scale = 1 },
			front_porch = { x = 300, y = 400, rotation = 3 * math.pi / 2, scale = 1 },
			backyard = { x = 690, y = 400, rotation = 3 * math.pi / 2, scale = 1 },
		},
	},

	-- -- NODE 22: Park
	-- -- FIXME: Maybe add wooded area with Trees
	-- [22] = {
	-- 	id = 22,
	-- 	name = "park",
	-- 	description = "Park",
	-- 	imagePath = nil,
	-- 	paths = {
	-- 		road_4 = 13,
	-- 		outside_house = 21,
	-- 		playground = 28,
	-- 		pond = 29,
	-- 	},
	-- },

	-- NODE 23: Front Porch
	[23] = {
		id = 23,
		name = "front_porch",
		description = "Front Porch",
		imagePath = "src/data/images/locations/front_porch.png",
		paths = {
			outside_house = 21,
			living_room = 26,
		},
		items = {
			"front_door",
		},
		arrows = {
			outside_house = { x = 100, y = 450, rotation = math.pi / 2, scale = 1 },
			living_room = { x = 390, y = 400, rotation = 3 * math.pi / 2, scale = 1 },
		},
	},

	-- NODE 24: Backyard
	-- FIXME: Doggy door will go to the kitchen (should the path name be doggy_door or kitchen here?)
	-- FIXME: backyard will have a hose to polish your can? (but if pond hurts can then would hose?)
	[24] = {
		id = 24,
		name = "backyard",
		description = "Backyard",
		imagePath = "src/data/images/locations/backyard.png",
		paths = {
			kitchen = 25,
			outside_house = 21,
		},
		arrows = {
			kitchen = { x = 585, y = 410, rotation = 3 * math.pi / 2, scale = 0.75 },
			outside_house = { x = 195, y = 395, rotation = 3 * math.pi / 2, scale = 1 },
		},
	},

	-- NODE 25: Kitchen
	[25] = {
		id = 25,
		name = "kitchen",
		description = "Kitchen",
		imagePath = "src/data/images/locations/kitchen.png",
		paths = {
			backyard = 24,
			living_room = 26,
		},
		arrows = {
			backyard = { x = 150, y = 400, rotation = math.pi / 2, scale = 1 },
			living_room = { x = 720, y = 450, rotation = 0, scale = 1 },
		},
	},

	-- NODE 26: Living Room
	[26] = {
		id = 26,
		name = "living_room",
		description = "Living Room",
		imagePath = "src/data/images/locations/living_room.png",
		paths = {
			kitchen = 25,
			victory_bowl = 27,
			front_porch = 23,
		},
		arrows = {
			kitchen = { x = 50, y = 300, rotation = math.pi, scale = 1 },
			victory_bowl = { x = 650, y = 365, rotation = 0, scale = 1 },
			front_porch = { x = 750, y = 280, rotation = 3 * math.pi / 2, scale = 1 },
		},
	},

	-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!! VICTORY BOWL !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	-- NODE 27: Victory Bowl
	-- FIXME: This has no paths, should i make it lead to itself or nothing?
	[27] = {
		id = 27,
		name = "victory_bowl",
		description = "Victory Bowl. You Win!",
		imagePath = "src/data/images/locations/victory_bowl.png",
		paths = {},
	},

	-- -- NODE 28: Playground
	-- -- FIXME: Add event of children kicking the can if the can enters here, also maybe add an incentive to come here?
	-- [28] = {
	-- 	id = 28,
	-- 	name = "playground",
	-- 	description = "Playground",
	-- 	imagePath = "src/data/images/locations/playground.png",
	-- 	paths = {
	-- 		park = 22,
	-- 	},
	-- },

	-- -- NODE 29: Pond
	-- -- FIXME: Can will rust/get a soggy label?
	-- -- FIXME: Add harry potter sword to the bottom of the pond?
	-- [29] = {
	-- 	id = 29,
	-- 	name = "pond",
	-- 	description = "Pond (underwater)",
	-- 	imagePath = nil,
	-- 	paths = {
	-- 		house_bathroom = 30,
	-- 	},
	-- },

	-- -- NODE 30: House Bathroom
	-- [30] = {
	-- 	id = 30,
	-- 	name = "house_bathroom",
	-- 	description = "House Bathroom. Can emerges from the toilet",
	-- 	imagePath = nil,
	-- 	paths = {
	-- 		living_room = 26,
	-- 	},
	-- },

	-- NODE 31: Dumpster Fire
	-- FIXME: Add functionality so that the player can put out the fire if they have an extinguisher
	[31] = {
		id = 31,
		name = "dumpster_fire",
		description = "The dumpster is on fire but you see something shiny in the flames.",
		imagePath = "src/data/images/locations/dumpster_fire.png",
		paths = {
			sketchy_alley = 12,
		},
		items = {
			{ id = "dumpster_fire", x = 130, y = -1, w = 400, h = 500 },
			
		},
		arrows = {
			sketchy_alley = { x = 50, y = 450, rotation = math.pi / 2, scale = 1 },
		},
	},

	-- -- NODE 32: Movers House
	-- -- FIXME: add a pogo stick item here for player to collect
	-- [32] = {
	-- 	id = 32,
	-- 	name = "movers_house",
	-- 	description = "House with movers out front",
	-- 	imagePath = nil,
	-- 	paths = {
	-- 		neighborhood_street = 10,
	-- 	},
	-- },

	-- -- NODE 33: Recycling House
	-- -- FIXME: make this place more existential
	-- [33] = {
	-- 	id = 33,
	-- 	name = "recycling_house",
	-- 	description = "House with recycling bin full of empty cans. Their labels peeled off.",
	-- 	imagePath = nil,
	-- 	paths = {
	-- 		neighborhood_street = 10,
	-- 	},
	-- },

	-- -- NODE 34: Behind the Grocery Store
	-- [34] = {
	-- 	id = 34,
	-- 	name = "behind_store",
	-- 	description = "Behind the Grocery Store",
	-- 	imagePath = nil,
	-- 	paths = {
	-- 		outside_house = 21, -- sewer grate here goes straight to the house,
	-- 	},
	-- },

}
