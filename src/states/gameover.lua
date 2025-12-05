-- src/states/gameover.lua
local GameOver = {}

function GameOver.update(dt)
    -- No logic needed for static screen
end

function GameOver.draw()
    love.graphics.clear(0, 0, 0)
    love.graphics.setColor(1, 0, 0)
    love.graphics.printf("YOU ARE EXPIRED (GAME OVER)", 0, 250, 800, "center")
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Press 'R' to Restart", 0, 300, 800, "center")
end

function GameOver.keypressed(key)
    if key == "r" then
        love.event.quit("restart") -- Simplest way to restart the whole game
    end
end

return GameOver