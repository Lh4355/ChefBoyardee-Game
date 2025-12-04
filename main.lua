-- main.lua
local Node = require("src.node")
local Item = require("src.item")
local map_nodes_data = require("src.data.map_nodes")

-- Define these at the top with "local" so they are seen by the whole file
local nodes = {}
local currentNode
local gamestate
local player

-- GUI CONFIGURATION (Day 3)
local GUI = {
    inv_slot_size = 50, -- Size of the inventory boxes
    inv_padding = 10,   -- Space between boxes
    inv_start_x = 50,   -- Starting X position
    inv_start_y = 500,  -- Starting Y position (Bottom of a 600px screen)
    item_scene_size = 40 -- Size of the "item" squares in the world
}

-- MOUSE INTERACTION STORAGE
-- We'll clear this every frame in love.draw and populate it with clickable areas
local clickZones = {}

function love.load()
    io.stdout:setvbuf("no")
    print("------------------------------------------------")
    print("LOADING NODES...")

    -- Iterate through the raw data and create Node objects
    for id, data in ipairs(map_nodes_data) do
        local name = data.name or "Unnamed"
        local newNode = Node.new(data.id, name, data.description, data.imagePath)
        
        -- Store the node
        nodes[id] = newNode

        if data.imagePath then
             -- Safety wrapper for image loading
             local status, err = pcall(function() newNode.image = love.graphics.newImage(data.imagePath) end)
             if not status then print("Error loading image for node " .. id .. ": " .. err) end
        end

        newNode.paths = data.paths
        print(newNode.id .. ". " .. newNode.name)
    end
    print("------------------------------------------------")
    print("NODES LOADED SUCCESSFULLY")

    -- PLAYER SETUP
    player = {
        name = "Chef Can",
        health = 100,
        x = 400,
        y = 300,
        inventory = {},
    }

    -- STARTING STATE
    currentNode = nodes[1]
    gamestate = "explore"

    -- TEST ITEM SETUP (Day 3)
    -- We give the item X/Y coordinates so it appears in the scene
    local testItem = Item.new("rusty_key", "Rusty Key", "An old key.", "gfx_key")
    testItem.x = 400 
    testItem.y = 400
    testItem.w = GUI.item_scene_size
    testItem.h = GUI.item_scene_size
    
    table.insert(nodes[1].items, testItem)
    print("DEBUG: Added Rusty Key to Node 1 at (400, 400)")
end

-- HELPER: Simple AABB Collision Detection
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

-- INVENTORY LOGIC
function PickUp(itemId)
    -- 1. Check if inventory is full (Max 8 slots)
    if #player.inventory >= 8 then
        print("Inventory is full! Cannot pick up " .. itemId)
        return
    end

    -- 2. Find the item in the current node
    local itemIndex = nil
    local itemObj = nil

    for i, item in ipairs(currentNode.items) do
        if item.id == itemId then
            itemIndex = i
            itemObj = item
            break
        end
    end

    -- 3. If found, transfer it
    if itemObj then
        table.remove(currentNode.items, itemIndex)
        table.insert(player.inventory, itemObj)
        print("Picked up: " .. itemObj.name)
    else
        print("Item " .. itemId .. " is not here.")
    end
end

function love.update(dt)
    -- Update logic here if needed
end

-- MOUSE CLICK LOGIC (Day 3)
function love.mousepressed(x, y, button)
    if button == 1 then -- Left Click
        -- Iterate through all active zones (items, paths) to see what was clicked
        for _, zone in ipairs(clickZones) do
            if CheckCollision(x, y, 1, 1, zone.x, zone.y, zone.w, zone.h) then
                
                if zone.type == "item" then
                    -- CLICKED AN ITEM
                    PickUp(zone.id)
                
                elseif zone.type == "path" then
                    -- CLICKED A PATH OPTION
                    if nodes[zone.targetId] then
                        currentNode = nodes[zone.targetId]
                        print("Moved to: " .. currentNode.name)
                    end
                end
                
                -- Stop checking after finding one valid click
                return
            end
        end
    end
end

-- KEYBOARD LOGIC (Day 3)
function love.keypressed(key)
    
    -- INVENTORY HOTKEYS (1-8)
    local n = tonumber(key)
    if n and n >= 1 and n <= 8 then
        local item = player.inventory[n]
        if item then
            print("--- INSPECT SLOT " .. n .. " ---")
            print("Name: " .. item.name)
            print("Desc: " .. item.description)
        else
            print("Slot " .. n .. " is empty.")
        end
    end
end

function love.draw()
    -- Clear click zones for this frame (we rebuild them based on what is drawn)
    clickZones = {}

    if gamestate == "explore" then
        -- 1. Draw Background
        if currentNode.image then
             local windowWidth = love.graphics.getWidth()
             local windowHeight = love.graphics.getHeight()
             local imageWidth = currentNode.image:getWidth()
             local imageHeight = currentNode.image:getHeight()
             local scaleX = windowWidth / imageWidth
             local scaleY = windowHeight / imageHeight
             love.graphics.draw(currentNode.image, 0, 0, 0, scaleX, scaleY)
        end

        -- 2. Draw Description
        love.graphics.setColor(1, 1, 1) -- White
        love.graphics.printf(currentNode.description, 50, 50, 700, "left")

        -- 3. Draw Scene Items (Day 3: Clickable Squares)
        for i, item in ipairs(currentNode.items) do
            -- Use item's pos or default
            local ix = item.x or (100 + (i * 60))
            local iy = item.y or 400
            local iw = item.w or GUI.item_scene_size
            local ih = item.h or GUI.item_scene_size
            
            -- Draw Red Square (Placeholder Art)
            love.graphics.setColor(1, 0, 0) 
            love.graphics.rectangle("fill", ix, iy, iw, ih)
            
            -- Draw Label
            love.graphics.setColor(1, 1, 1)
            love.graphics.print(item.name, ix, iy - 20)

            -- Register this area as clickable
            table.insert(clickZones, {
                x = ix, y = iy, w = iw, h = ih,
                type = "item",
                id = item.id
            })
        end

        -- 4. Draw Path Options (Day 3: Clickable Text)
        local y = 200
        local index = 1
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Where do you want to roll?", 50, 170)

        for pathName, targetId in pairs(currentNode.paths) do
            local optionText = index .. ". Go to " .. pathName
            love.graphics.print(optionText, 50, y)
            
            -- Calculate text size for collision box
            local font = love.graphics.getFont()
            local textW = font:getWidth(optionText)
            local textH = font:getHeight()

            -- Register this area as clickable
            table.insert(clickZones, {
                x = 50, y = y, w = textW, h = textH,
                type = "path",
                targetId = targetId
            })

            y = y + 30
            index = index + 1
        end

        -- 5. Draw HUD / Inventory (Day 3)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("INVENTORY (Press 1-8)", GUI.inv_start_x, GUI.inv_start_y - 25)
        
        for i = 1, 8 do
            local bx = GUI.inv_start_x + (i-1) * (GUI.inv_slot_size + GUI.inv_padding)
            local by = GUI.inv_start_y
            
            -- Draw Box Outline
            love.graphics.rectangle("line", bx, by, GUI.inv_slot_size, GUI.inv_slot_size)
            
            -- Check content
            local item = player.inventory[i]
            if item then
                -- Draw Item Name (Small) inside box
                love.graphics.printf(item.name, bx, by + 15, GUI.inv_slot_size, "center")
            else
                -- Draw Slot Number (Greyed out)
                love.graphics.setColor(0.5, 0.5, 0.5)
                love.graphics.print(i, bx + 5, by + 5)
                love.graphics.setColor(1, 1, 1)
            end
        end

    elseif gamestate == "menu" then
        love.graphics.print("MAIN MENU (Press Enter to Start)", 300, 300)
    end
    
    -- Reset color
    love.graphics.setColor(1, 1, 1)
end