-- src/system/scene_renderer.lua
local Constants = require("src.constants")
local InputManager = require("src.system.input_manager")

local SceneRenderer = {}
local uiFontSmall

function SceneRenderer.init()
    -- Load font for paths
    local successSmall, fontSmall = pcall(love.graphics.newFont, "src/data/fonts/RINGM___.TTF", 16)
    if successSmall then uiFontSmall = fontSmall else uiFontSmall = love.graphics.newFont(16) end
end

function SceneRenderer.drawBackground(currentNode)
    if currentNode.image then
        local w, h = love.graphics.getDimensions()
        local imageWidth = currentNode.image:getWidth()
        local imageHeight = currentNode.image:getHeight()
        local scaleX = w / imageWidth
        local scaleY = h / imageHeight
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(currentNode.image, 0, 0, 0, scaleX, scaleY)
    end
end

function SceneRenderer.drawElements(currentNode)
    if not uiFontSmall then SceneRenderer.init() end
    local gui = Constants.GUI

    -- 1. Draw Items
    for i, item in ipairs(currentNode.items) do
        local ix, iy = item.x or (100 + i * 60), item.y or 400
        local iw, ih = item.w or gui.item_scene_size, item.h or gui.item_scene_size

        -- Draw Blue Box
        love.graphics.setColor(0, 0, 1)
        love.graphics.rectangle("fill", ix, iy, iw, ih)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(item.name, ix, iy - 20)

        -- Register Click
        InputManager.register(ix, iy, iw, ih, "item", item.id)
    end

    -- 2. Draw Navigation Paths
    local py = 150
    love.graphics.setFont(uiFontSmall)
    
    for pathName, targetId in pairs(currentNode.paths) do
        local txt = "Go to " .. pathName
        local tw = uiFontSmall:getWidth(txt)
        
        -- Text Background
        love.graphics.setColor(0,0,0,0.5) 
        love.graphics.rectangle("fill", 45, py, tw+10, 25)
        
        -- Text
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(txt, 50, py)
        
        -- Register Click
        InputManager.register(50, py, tw, 25, "path", targetId)
        
        py = py + 30
    end
end

return SceneRenderer