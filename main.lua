-- main.lua
local Initialization = require("src.system.initialization")
local AudioManager = require("src.system.audio_manager")
local GameState = require("src.system.game_state")

-- Import States
local Menu = require("src.states.menu")
local Explore = require("src.states.explore")
local GameOver = require("src.states.gameover")

local nodes = {}
local player
local currentState -- This holds the active state table (Menu or Explore)

function love.load()
	io.stdout:setvbuf("no")

	-- Initialize all game systems
	nodes = Initialization.initializeNodes()
	player = Initialization.initializePlayer()
	AudioManager.initializeAudio()

	-- Start Game in Menu
	SwitchState(Menu)
end

-- NEW FUNCTION: Handles switching states cleanly
function SwitchState(newState)
	currentState = GameState.switchState(currentState, newState, player, nodes)
end

function love.update(dt)
	if currentState.update then
		local signal = currentState.update(dt)
		-- specific signals to switch states
		if signal == "explore" then
			SwitchState(Explore)
		end
		if signal == "gameover" then
			SwitchState(GameOver)
		end
	end
end

function love.draw()
	if currentState.draw then
		currentState.draw()
	end
end

function love.mousepressed(x, y, button)
	if currentState.mousepressed then
		local signal = currentState.mousepressed(x, y, button)
		if signal == "explore" then
			SwitchState(Explore)
		end
	end
end

function love.keypressed(key)
	if currentState.keypressed then
		local signal = currentState.keypressed(key)
		if signal == "explore" then
			SwitchState(Explore)
		end
	end
end
