-- src/constants.lua
return {
	SCREEN_WIDTH = 800,
	SCREEN_HEIGHT = 600,
	GUI = {

		-- Inventory Strip Settings
		inv_panel_height = 100, -- Height of the green strip at bottom
		inv_slot_size = 50,
		inv_padding = 15,
		inv_start_x = 20, -- Padding from left wall

		-- Item interactions in the world
		item_scene_size = 40,

		-- Colors (r, g, b, a)
		COLORS = {
			green_panel = { 0, 0.5, 0.2, 1 }, -- The dark green bottom strip
			red_border = { 0.8, 0, 0, 1 }, -- Red inventory boxes/health
			health_bg = { 0.2, 0, 0, 1 }, -- Dark red background for health
			text_yellow = { 1, 0.9, 0.2, 1 }, -- Event text color
			black_box = { 0, 0, 0, 0.7 }, -- Background for Node Name
		},

	},
}
