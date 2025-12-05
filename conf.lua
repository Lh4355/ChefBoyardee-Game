local Constants = require("src.constants")

function love.conf(t)
    -- Identity
    t.identity = "ravioli_adventure" -- Unique name for save folder
    t.title = "The Rolling Can"      -- The text in the window title bar
    
    -- Window Settings
    t.window.width = Constants.SCREEN_WIDTH
    t.window.height = Constants.SCREEN_HEIGHT
    t.window.resizable = false       -- Can the player resize the window?
    t.window.vsync = true            -- Vertical sync (stops screen tearing)
    
    -- Debugging (Crucial for you!)
    t.console = true                 -- Opens a black console window alongside your game.
                                     -- You will see your print("Health is 0") messages here.
end