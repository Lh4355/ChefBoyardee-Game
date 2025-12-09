--[[
	File: /src/states/explore.lua
	Description: Explore State - Handles the main exploration gameplay state, including
	             node navigation, item interactions, minigames, and HUD rendering.
--]]

local Events = require("src.system.events")
local Interactions = require("src.system.interactions")
local ClickFiller = require("src.minigames.click_filler")
local Utils = require("src.utils")
local GameState = require("src.system.game_state")

-- Load Systems
local InputManager = require("src.system.input_manager")
local SceneRenderer = require("src.system.scene_renderer")
local HUD = require("src.system.hud")
local VolumeWidget = require("src.system.volume_widget")

local Explore = {}
local currentMinigame = nil

local player, nodes, currentNode
local eventMessage = ""
local selectedSlot = nil
local gameFlags = GameState.new() -- Initialize once for persistent state

function Explore.enter(pPlayer, pNodes, pStartNode)
	player = pPlayer
	nodes = pNodes
	currentNode = pStartNode
	eventMessage = ""
	selectedSlot = nil
	-- Do not reset gameFlags here; it should persist across state transitions

	-- Initialize Systems
	HUD.init()
	SceneRenderer.init()
	VolumeWidget.init()
	-- Mark starting node as visited
	if player and currentNode and player.visitNode then
		player:visitNode(currentNode.id)
	end
	Explore.loadNodeMinigame()
end

-- Loads the minigame for the current node if one is defined
function Explore.loadNodeMinigame()
	local minigame = currentNode.minigame

	if not minigame then
		currentMinigame = nil
		return
	end

	if minigame.type == "click_filler" then
		currentMinigame = ClickFiller.new(minigame)
	else
		currentMinigame = nil
	end
end

-- Resets all game state, player stats, and reinitializes nodes for a fresh playthrough
function Explore.resetGameState()
	gameFlags:reset(player, nodes)
end

-- Updates game state each frame: handles minigame updates, checks win condition, and returns state transition signals
function Explore.update(dt)
	VolumeWidget.update(dt)

	if player.health <= 0 then
		return "gameover"
	end

	if currentMinigame then
		local won, nextNodeId, msg = currentMinigame:update(dt)
		if won then
			Explore.enterNode(nextNodeId)
			eventMessage = msg
			return
		end
	end

	-- Check if we've reached the victory bowl (won game)
	if currentNode.id == 27 then
		return "won"
	end
end

-- Renders the explore state: background, minigame or interactive elements, and HUD
function Explore.draw()
	-- Reset Input Zones for this frame
	InputManager.clear()

	-- Draw World
	SceneRenderer.drawBackground(currentNode)

	-- Draw Minigame OR Items/Paths
	if currentMinigame then
		currentMinigame:draw()
	else
		SceneRenderer.drawElements(currentNode, gameFlags)
	end

	-- Draw HUD (Health, Inventory, Messages, Volume)
	HUD.draw(player, currentNode, eventMessage, selectedSlot)
end

function Explore.mousepressed(x, y, button)
	if button == 1 then
		if VolumeWidget.mousepressed(x, y, button) then
			return
		end

		-- Minigame priority
		if currentMinigame then
			local handled = currentMinigame:mousepressed(x, y)
			if handled then
				return
			end
		end

		-- Check Input Manager
		local type, data = InputManager.handleMousePressed(x, y)

		if type == "item" then
			Explore.pickUp(data)
		elseif type == "path" then
			Explore.enterNode(data)
		elseif type == "inventory" then
			-- Toggle selection
			if player.inventory[data] then
				selectedSlot = data
			else
				selectedSlot = nil
			end
		else
			-- Clicked nothing (deselect)
			selectedSlot = nil
		end
	end
end

-- Attempts to transition to a target node, checking entry conditions and triggering node events
function Explore.enterNode(targetId)
	local prevNode = currentNode
	local targetNode = nodes[targetId]
	local allowed, msg = Events.checkEnter(targetNode, player, gameFlags, prevNode)
	-- Set event message regardless of success
	eventMessage = msg or ""

	-- If not allowed to enter, abort
	if not allowed then
		return
	end

	-- Transition to target node
	currentNode = targetNode
	selectedSlot = nil
	-- Mark the node as visited for tracking
	if player and currentNode and player.visitNode then
		player:visitNode(currentNode.id)
	end

	-- If the player is leaving intersection_1 (node 5) on its first visit
	-- and they did not enter the jewelry store (17), mark the robbery as missed.
	if prevNode and prevNode.id == 5 then
		gameFlags:handleMissedJewelryRobbery(nodes, player)
	end
	-- Load any minigame for the new node
	Explore.loadNodeMinigame()
end

-- Handles item interaction and pickup logic, including item-use interactions and inventory management
function Explore.pickUp(itemId)
	-- Get selected item ID from inventory slot if one is selected
	local selectedItemId = nil
	if selectedSlot and player.inventory[selectedSlot] then
		selectedItemId = player.inventory[selectedSlot].id
	end

	-- Locate the item once (capture both object and index)
	local itemObj, itemIndex
	for i, item in ipairs(currentNode.items) do
		if item.id == itemId then
			itemObj = item
			itemIndex = i
			break
		end
	end

	-- Helper function to apply interaction results and update state
	local function applyInteractionResult(handled, msg)
		-- If interaction was handled, update game flags and clear selection
		if not handled then
			return false
		end

		-- Interaction succeeded
		-- Set event message
		eventMessage = msg or ""
		-- 
		gameFlags:handleSketchyAlleyUpdate(nodes)
		selectedSlot = nil
		return true
	end

	-- If the item cannot be picked up, only allow interaction
	if itemObj and not itemObj.canPickup then
		local handled, msg = Interactions.tryInteract(itemId, player, currentNode, gameFlags, selectedItemId)
		if applyInteractionResult(handled, msg) then
			return
		end
		-- Interaction failed, show the message but don't allow pickup
		eventMessage = msg or ""
		return
	end

	-- First try interaction (with selected item if any)
	local handled, msg = Interactions.tryInteract(itemId, player, currentNode, gameFlags, selectedItemId)
	
	-- If interaction succeeded, update state and exit
	if applyInteractionResult(handled, msg) then
		return
	end
	
	-- If no interaction occurred, attempt to pick up the item
	if itemObj then
		if player:addItem(itemObj) then
			table.remove(currentNode.items, itemIndex)
			eventMessage = "Picked up: " .. itemObj.name
		else
			eventMessage = "Inventory Full!"
		end
	end
end

return Explore
