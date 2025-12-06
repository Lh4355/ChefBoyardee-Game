-- src/system/hud.lua
local Constants = require("src.constants")
local InputManager = require("src.system.input_manager")

local HUD = {}
local uiFont, uiFontSmall

function HUD.init()
    -- Load fonts safely
    local success, font = pcall(love.graphics.newFont, "src/data/fonts/RINGM___.TTF", 24)
    if success then uiFont = font else uiFont = love.graphics.newFont(24) end
    
    local successSmall, fontSmall = pcall(love.graphics.newFont, "src/data/fonts/RINGM___.TTF", 16)
    if successSmall then uiFontSmall = fontSmall else uiFontSmall = love.graphics.newFont(16) end
end

function HUD.draw(player, currentNode, eventMessage, selectedSlot)
    local w, h = love.graphics.getDimensions()
    local gui = Constants.GUI

    -- Ensure fonts are loaded
    if not uiFont then HUD.init() end

    -- 1. BOTTOM GREEN PANEL (Inventory)
    local panelY = h - gui.inv_panel_height
    love.graphics.setColor(unpack(gui.COLORS.green_panel))
    love.graphics.rectangle("fill", 0, panelY, w, gui.inv_panel_height)

    -- Inventory Label
    love.graphics.setColor(0.8, 0, 0) -- Reddish Text
    love.graphics.setFont(uiFontSmall)
    love.graphics.print("Inventory", 20, panelY + 5)

    -- Draw Slots (Red Boxes)
    for i = 1, 8 do
        local bx = gui.inv_start_x + (i - 1) * (gui.inv_slot_size + gui.inv_padding)
        local by = panelY + 30 

        -- Draw Slot Border
        love.graphics.setLineWidth(3)
        if i == selectedSlot then
            love.graphics.setColor(1, 1, 0) -- Yellow if selected
        else
            love.graphics.setColor(unpack(gui.COLORS.red_border)) -- Red otherwise
        end
        love.graphics.rectangle("line", bx, by, gui.inv_slot_size, gui.inv_slot_size)

        -- Draw Slot Number
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.print(tostring(i), bx + 2, by + 2)

        -- Draw Item Name
        if player.inventory[i] then
            love.graphics.setColor(1, 1, 1)
            love.graphics.setFont(love.graphics.newFont(10)) 
            love.graphics.printf(player.inventory[i].name, bx, by + 15, gui.inv_slot_size, "center")
        end

        -- REGISTER CLICK ZONE
        InputManager.register(bx, by, gui.inv_slot_size, gui.inv_slot_size, "inventory", i)
    end

    -- Description Text
    love.graphics.setFont(uiFont)
    if selectedSlot and player.inventory[selectedSlot] then
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(player.inventory[selectedSlot].description, 550, panelY + 25, 230, "left")
    else
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.printf("Select item for info", 550, panelY + 25, 230, "left")
    end

    -- 2. TOP LEFT: HEALTH BAR
    love.graphics.setColor(unpack(gui.COLORS.health_bg))
    love.graphics.rectangle("fill", 20, 20, 250, 30)
    
    love.graphics.setColor(1, 0, 0)
    local healthWidth = (player.health / 100) * 250
    love.graphics.rectangle("fill", 20, 20, healthWidth, 30)
    
    love.graphics.setColor(0, 0, 0)
    love.graphics.setLineWidth(4)
    love.graphics.rectangle("line", 20, 20, 250, 30)
    
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(uiFontSmall)
    love.graphics.print("Health: " .. player.health .. "%", 280, 25)

    -- 3. TOP CENTER: NODE NAME
    local nodeName = currentNode.name:upper()
    local nw = uiFont:getWidth(nodeName)
    love.graphics.setColor(unpack(gui.COLORS.red_border)) 
    love.graphics.rectangle("fill", w / 2 - nw / 2 - 10, 20, nw + 20, 35)
    love.graphics.setColor(0, 0, 0) 
    love.graphics.print(nodeName, w / 2 - nw / 2, 25)

    -- 4. TOP RIGHT: SKIN BOX
    local skinBoxSize = 60
    local sbX = w - 90
    local sbY = 20

    love.graphics.setColor(0.5, 0.5, 0.5) 
    love.graphics.rectangle("fill", sbX, sbY, skinBoxSize, skinBoxSize)
    
    love.graphics.setColor(0, 0.6, 0) 
    love.graphics.setLineWidth(5)
    love.graphics.rectangle("line", sbX, sbY, skinBoxSize, skinBoxSize)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(10))
    love.graphics.print("Skin: " .. player.skin, sbX, sbY - 15)

    if player.skin == "gold" then
        love.graphics.setColor(1, 0.8, 0) 
    else
        love.graphics.setColor(0.8, 0, 0) 
    end
    love.graphics.circle("fill", sbX + 30, sbY + 30, 15)

    -- 5. EVENT MESSAGES
    if eventMessage ~= "" then
        local msgW = uiFont:getWidth(eventMessage)
        love.graphics.setColor(0, 0, 0, 0.8) 
        love.graphics.rectangle("fill", w / 2 - msgW / 2 - 10, panelY - 40, msgW + 20, 30)
        
        love.graphics.setColor(unpack(gui.COLORS.text_yellow))
        love.graphics.printf(eventMessage, 0, panelY - 35, w, "center")
    end
    
    love.graphics.setColor(1, 1, 1, 1) -- Reset
end

return HUD