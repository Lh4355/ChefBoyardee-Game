-- src/system/input_manager.lua
local Utils = require("src.utils")

local InputManager = {}
local zones = {}

function InputManager.clear()
    zones = {}
end

function InputManager.register(x, y, w, h, type, data)
    table.insert(zones, {x=x, y=y, w=w, h=h, type=type, data=data})
end

function InputManager.handleMousePressed(x, y)
    for _, zone in ipairs(zones) do
        if Utils.checkCollision(x, y, 1, 1, zone.x, zone.y, zone.w, zone.h) then
            return zone.type, zone.data
        end
    end
    return nil
end

return InputManager