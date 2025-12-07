-- main.lua
local Node = require("src.entities.node")
local Item = require("src.entities.item")
local Player = require("src.entities.player")
local map_nodes_data = require("src.data.map_nodes")

-- Import States
local Menu = require("src.states.menu")
local Explore = require("src.states.explore")
local GameOver = require("src.states.gameover")

local nodes = {}
local player
local currentState -- This holds the active state table (Menu or Explore)

function love.load()
	io.stdout:setvbuf("no")

	-- 1. Load Nodes
	for id, data in pairs(map_nodes_data) do
		local newNode = Node.new(data.id, data.name or "Unnamed", data.description, data.imagePath)
		nodes[id] = newNode
		if data.imagePath then
			pcall(function()
				newNode.image = love.graphics.newImage(data.imagePath)
			end)
		end
		newNode.paths = data.paths -- Load paths
		newNode.items = newNode.items or {} -- Initialize items table

		newNode.minigame = data.minigame -- Load minigame data if present
	end

	-- 2. Setup Player
	player = Player.new("Chef Can", 400, 300)

	-- 3. Add Test Item (Logic moved from main to here is fine for setup)
	-- Note: Ideally this data belongs in map_nodes.lua, but this works for now.
	local Constants = require("src.constants")
	local testItem = Item.new("rusty_key", "Rusty Key", "An old key.", "gfx_key")
	testItem.w = Constants.GUI.item_scene_size
	testItem.h = Constants.GUI.item_scene_size
	table.insert(nodes[2].items, testItem)

	-- 4. Load and Play Background Music
	-- "stream" tells Love2D to stream it from the disk (good for long music)
	-- "static" would be used for short sound effects (keeps it in memory)
	local music = love.audio.newSource("src/data/audio/chef_music.mp3", "stream")
	music:setLooping(true) -- Make it repeat forever
	-- music:setVolume(0.5)   -- Set volume (0.0 to 1.0)
	music:setVolume(0.0) -- FIXME: Muted for now, uncomment out line above to enable music and delete this line
	music:play()

	-- 4. Start Game in Menu
	SwitchState(Menu)
end

-- NEW FUNCTION: Handles switching states cleanly
function SwitchState(newState)
	currentState = newState
	-- Pass shared data (player, nodes) to the state if it needs it
	if currentState.enter then
		currentState.enter(player, nodes, nodes[1])
	end
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
