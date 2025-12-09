--[[
	File: /src/constants.lua
	Description: This file contains constant values used throughout the game.
--]]

return {
	SCREEN_WIDTH = 800,
	SCREEN_HEIGHT = 600,
	GUI = {

		-- Inventory Strip Settings
		inv_panel_height = 90, -- Height of the inventory bar
		inv_slot_size = 50, -- Slot size for inventory
		inv_padding = 15, -- Padding between slots
		inv_start_x = 15, -- Padding from left wall

		-- Default Item Scene Size (w x h)
		item_scene_size = 40,

		-- Colors
		COLORS = {
			green_panel = { 0, 0.5, 0.2, 1 }, -- The dark green bottom strip
			cream = { 0.941, 0.812, 0.573 }, -- Red inventory boxes/health
			red = { 0.82, 0.11, 0.15 }, -- Dark red background for health
			text_yellow = { 1, 0.9, 0.2, 1 }, -- Event text color
            grey = { 0.60, 0.62, 0.64 }, -- Grey color for background of health bar
		},
	},
}
