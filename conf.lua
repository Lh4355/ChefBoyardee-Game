local Constants = require("src.constants")

function love.conf(t)
    -- Identity
    t.identity = "chef_boyardee_simulator"   -- name for save file folder (not implemented yet)
    t.title = "Chef Boyardee Simulator"      -- The text in the window title bar

    -- Window Settings
    t.window.width = Constants.SCREEN_WIDTH
    t.window.height = Constants.SCREEN_HEIGHT
    t.window.resizable = false
    t.window.vsync = true

    -- Debugging
    -- t.console = true                  -- Enable debug console window (Windows only)
end