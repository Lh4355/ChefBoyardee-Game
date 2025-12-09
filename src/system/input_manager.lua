--[[
    File: src/system/input_manager.lua
    Description: Manages interactive zones for mouse input handling.
--]]

local Utils = require("src.utils")

local InputManager = {}

-- Tracks all registered interactive rectangles for the current frame
local zones = {}

function InputManager.clear()
	-- Reset zones when changing scenes or reinitializing input
	zones = {}
end

function InputManager.register(x, y, w, h, type, data)
	-- Store a rectangular hitbox with associated type and optional data payload
	table.insert(zones, { x = x, y = y, w = w, h = h, type = type, data = data })
end

function InputManager.handleMousePressed(x, y)
	-- Return the first zone that contains the mouse press
	for _, zone in ipairs(zones) do
		if Utils.checkCollision(x, y, 1, 1, zone.x, zone.y, zone.w, zone.h) then
			return zone.type, zone.data
		end
	end
	return nil
end

return InputManager
