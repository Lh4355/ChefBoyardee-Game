function love.conf(t)
    -- Identity
    t.identity = "ravioli_adventure" -- Unique name for save folder
    t.title = "The Rolling Can"      -- The text in the window title bar
    
    -- Window Settings
    t.window.width = 800             -- Window width in pixels
    t.window.height = 600            -- Window height in pixels
    t.window.resizable = false       -- Can the player resize the window?
    t.window.vsync = true            -- Vertical sync (stops screen tearing)
    
    -- Debugging (Crucial for you!)
    t.console = true                 -- Opens a black console window alongside your game.
                                     -- You will see your print("Health is 0") messages here.
end