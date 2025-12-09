--[[
	File: main.lua
	Description: Main entry point for Chef Boyardee Simulator game.
	             Sets up LÖVE framework callbacks, initializes game objects,
	             and manages state transitions between Menu, Explore, GameOver, and Won states.
--]]

-- Import System modules
local Initialization = require("src.system.initialization")
local AudioManager = require("src.system.audio_manager")
local GameState = require("src.system.game_state")

-- Import State modules (Menu, Explore, GameOver, Won)
local Menu = require("src.states.menu")
local Explore = require("src.states.explore")
local GameOver = require("src.states.gameover")
local Won = require("src.states.game_won")

-- Global game objects shared across states
local nodes = {}
local player
local currentState -- Active state table with update/draw/input callbacks

-- Initializes game objects and enters Menu state
function love.load()
	-- Disable output buffering for real-time console logs
	io.stdout:setvbuf("no")

	-- Initialize game objects: load map nodes and player from data
	nodes = Initialization.initializeNodes()
	player = Initialization.initializePlayer()

	-- Load and initialize all audio resources
	AudioManager.initializeAudio()

	-- Enter menu state (main menu)
	SwitchState(Menu)
end

-- Switches the current game state to a new state
function SwitchState(newState)
	currentState = GameState.switchState(currentState, newState, player, nodes)
end

-- Updates frame in LÖVE framework (in delta time dt)
function love.update(dt)
	-- Delegate update logic to active state
	if currentState.update then
		local signal = currentState.update(dt)
		-- Process state transition signals returned by update logic
		if signal == "explore" then
			SwitchState(Explore)
		elseif signal == "gameover" then
			SwitchState(GameOver)
		elseif signal == "won" then
			SwitchState(Won)
		elseif signal == "menu" then
			SwitchState(Menu)
		end
	end
end

-- Render graphics each frame
function love.draw()
	-- Delegate drawing to the current active state
	if currentState.draw then
		currentState.draw()
	end
end

-- Handles mouse input
function love.mousepressed(x, y, button)
	-- Delegate mouse input to active state
	if currentState.mousepressed then
		local signal = currentState.mousepressed(x, y, button)
		-- Process state transition signals from mouse input
		if signal == "explore" then
			SwitchState(Explore)
		elseif signal == "menu" then
			SwitchState(Menu)
		elseif signal == "won" then
			SwitchState(Won)
		end
	end
end

-- Handles keyboard input
function love.keypressed(key)
	-- Delegate keyboard input to active state
	if currentState.keypressed then
		local signal = currentState.keypressed(key)
		-- Process state transition signals from keyboard input
		if signal == "explore" then
			SwitchState(Explore)
		end
	end
end
