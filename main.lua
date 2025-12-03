-- main.lua
local Node = require("src.node")
local map_nodes_data = require("src.data.map_nodes")

-- Define these at the top with "local" so they are seen by the whole file,
-- but don't leak into other files.
local nodes = {} 
local currentNode
local gamestate

function love.load()
    -- Open the console (already set in conf.lua, but ensures you see output)
    io.stdout:setvbuf("no") 
    print("------------------------------------------------")
    print("LOADING NODES...")
    print("------------------------------------------------")

    -- Iterate through the raw data and create Node objects
    for id, data in ipairs(map_nodes_data) do
        -- Safety check: Use "Unnamed" if you haven't added the name to map_nodes.lua yet
        local name = data.name or "Unnamed" 
        
        -- Create the new node instance
        -- Node.new params: id, name, description, imagePath
        local newNode = Node.new(data.id, name, data.description, data.imagePath)
        
        -- Store the node in our global table
        nodes[id] = newNode
        
        -- copy paths over (as discussed in previous analysis)
        newNode.paths = data.paths

        -- PRINT TO DEBUG WINDOW
        print(newNode.id .. ". " .. newNode.name)
    end

    print("------------------------------------------------")
    print("NODES LOADED SUCCESSFULLY")
    print("------------------------------------------------")
                       

    -- EXISTING PLAYER SETUP
    player = {
        name = "Chef Can",
        health = 100,
        x = 400,
        y = 300
    }

    -- ------------------------------------
    -- STEP 1: Set Starting Node
    currentNode = nodes[1] 
    
    -- STEP 2: State Manager Setup
    gamestate = "explore" -- Options: "menu", "explore", "map"

    -- --------------------------       

end

function love.update(dt)
    -- SIMPLE TEST: Move the player right if D is pressed
    if love.keyboard.isDown("d") then
        player.x = player.x + (100 * dt) 
    end
end


-- STEP 3: Move Logic
function love.keypressed(key)
    if gamestate == "explore" then
        -- We need to map the user's key press (1, 2, 3) to the available paths
        local pathIndex = 1
        for _ , targetId in pairs(currentNode.paths) do
            if key == tostring(pathIndex) then
                -- Move the player!
                if nodes[targetId] then
                    currentNode = nodes[targetId]
                    print("Moved to: " .. currentNode.name)
                else
                    print("Error: Node " .. targetId .. " does not exist.")
                end
            end
            pathIndex = pathIndex + 1
        end
    end
end


-- STEP 4: Display Text Interface
function love.draw()
    if gamestate == "explore" then
        -- 1. Draw the Background/Description
        love.graphics.printf(currentNode.description, 50, 50, 700, "left")
        
        -- 2. Draw the Options (Paths)
        local y = 200
        local index = 1
        
        love.graphics.print("Where do you want to roll?", 50, 170)
        
        for pathName, _ in pairs(currentNode.paths) do
            local optionText = index .. ". Go to " .. pathName
            love.graphics.print(optionText, 50, y)
            y = y + 30
            index = index + 1
        end
        
    elseif gamestate == "menu" then
        love.graphics.print("MAIN MENU (Press Enter to Start)", 300, 300)
    end
    
    -- Debug helper
    love.graphics.print("Current Node ID: " .. currentNode.id, 10, 550)
end