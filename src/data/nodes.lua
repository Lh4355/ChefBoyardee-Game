-- src/data/nodes.lua

return {
	-- NODE 1: Shelf (starting node)
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
			shakeSpeed = 30,      -- Higher number = faster vibration
		},
	},

	-- NODE 2: The Aisle Floor
	[2] = {
		id = 2,
		name = "aisle_floor",
		description = "You leap off the shelf. The tiles are cold under your ridges. You see the exit to the store ahead.",
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

	-- NODE 5: Main Intersection
	[5] = {
		id = 5,
		name = "intersection_1",
		description = "Narrowly avoiding oncoming traffic, you reach a busy intersection. There is a highway and a storefront with glittering windows.",
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

	-- NODE 8: Scary Highway
	[8] = {
		id = 8,
		name = "scary_highway",
		description = "You roll along the shoulder of a busy highway. Cars zoom past you at terrifying speeds. The noise is overwhelming.",
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

	-- NODE 10: Neighborhood Street
	[10] = {
		id = 10,
		name = "neighborhood_street",
		description = "You find yourself on a quiet neighborhood street. New neighbors are moving in, probably for this area's recycling pick-up program.",
		imagePath = "src/data/images/locations/neighborhood_street.png",
		paths = {
			steep_hill = 11,
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
		description = "This steep hill is dangerous, but you feel the training the cannery instilled in you and continue onward.",
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
	[12] = {
		id = 12,
		name = "sketchy_alley",
		description = "This alley looks like bad news. And its suddenly nightime. You smell something burning...",
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

	-- NODE 17: Jewelry Store
	[17] = {
		id = 17,
		name = "jewelry_store",
		description = "Glittering jewels and gold adorn the displays of the jewelry store. You can even see the reflection of you can on the floor.",
		imagePath = "src/data/images/locations/jewelry_store_robbery.png",
		paths = {
			intersection_1 = 5,
		},
		arrows = {
			intersection_1 = { x = 400, y = 450, rotation = math.pi / 2, scale = 1 },
		},
	},

	-- NODE 21: Outside of House
	[21] = {
		id = 21,
		name = "outside_house",
		description = "A strange warm feeling overwhelms you as you approach the house. You see a front porch and a backyard.",
		imagePath = "src/data/images/locations/outside_house.png",
		paths = {
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

	-- NODE 23: Front Porch
	[23] = {
		id = 23,
		name = "front_porch",
		description = "A dog sleeps on the front porch. You can almost hear the sound of the microwave beeping in your head. You're so close.",
		imagePath = "src/data/images/locations/front_porch.png",
		paths = {
			outside_house = 21,
			living_room = 26,
		},
		items = {
			{ id = "front_door" , x = 310, y = 280, w = 30, h = 30 },
		},
		arrows = {
			outside_house = { x = 100, y = 450, rotation = math.pi / 2, scale = 1 },
			living_room = { x = 390, y = 400, rotation = 3 * math.pi / 2, scale = 1 },
		},
	},

	-- NODE 24: Backyard
	[24] = {
		id = 24,
		name = "backyard",
		description = "The backyard is peaceful. You see a garden gnome staring at you menacingly. The dog leads you to a doggy door.",
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
		description = "The kitchen is warm and inviting. The smell of Chef Boyardee from dinners past lingers in the air.",
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
		description = "The living room is cozy. You roll over to the human child and stare at them with your label facing outwards.",
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
	[27] = {
		id = 27,
		name = "victory_bowl",
		description = "Victory Bowl. You Win!",
		imagePath = "src/data/images/locations/victory_bowl.png",
		paths = {},
	},


	-- NODE 31: Dumpster Fire
	[31] = {
		id = 31,
		name = "dumpster_fire",
		description = "The smell of burning trash fills your canstrils. The dumpster is on fire but you see something shiny in the flames.",
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

}
