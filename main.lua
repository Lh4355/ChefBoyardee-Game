-- DAY 1 SKELETON CODE

function love.load()
    -- This runs once when the game opens.
    -- We will put our "Node" setup here later.
    print("Game Loaded!") -- Look at the black console window to see this!
    
    player = {
        name = "Chef Can",
        health = 100,
        x = 400,
        y = 300
    }
end

function love.update(dt)
    -- This runs 60 times a second.
    -- "dt" stands for "delta time" (time since last frame).
    
    -- SIMPLE TEST: Move the player right if D is pressed
    if love.keyboard.isDown("d") then
        player.x = player.x + (100 * dt) -- Move 100 pixels per second
    end
end

function love.draw()
    -- This draws shapes and images to the screen.
    
    -- Draw a red square representing our Can (Placeholder Art)
    love.graphics.setColor(1, 0, 0) -- Red (Red, Green, Blue)
    love.graphics.rectangle("fill", player.x, player.y, 50, 50)
    
    -- Reset color to white for text
    love.graphics.setColor(1, 1, 1) 
    love.graphics.print("Current Health: " .. player.health, 10, 10)
    love.graphics.print("Press 'D' to move the square", 10, 30)
end