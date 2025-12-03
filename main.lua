-- main.lua
local Node = require("src.node")
local map_nodes_data = require("src.data.map_nodes") -- Import the raw data

-- Global table to store the actual loaded Node objects
nodes = {} 

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
end

function love.update(dt)
    -- SIMPLE TEST: Move the player right if D is pressed
    if love.keyboard.isDown("d") then
        player.x = player.x + (100 * dt) 
    end
end

function love.draw()
    -- Draw a red square representing our Can 
    love.graphics.setColor(1, 0, 0) 
    love.graphics.rectangle("fill", player.x, player.y, 50, 50)
    
    -- Reset color to white for text
    love.graphics.setColor(1, 1, 1) 
    love.graphics.print("Current Health: " .. player.health, 10, 10)
    love.graphics.print("Check the console window for loaded nodes!", 10, 30)
end