-- src/states/explore.lua
local Events = require("src.system.events")
local Interactions = require("src.system.interactions")
local ClickFiller = require("src.minigames.click_filler")

-- Load Systems
local InputManager = require("src.system.input_manager")
local SceneRenderer = require("src.system.scene_renderer")
local HUD = require("src.system.hud")

local Explore = {}
local currentMinigame = nil

local player, nodes, currentNode
local eventMessage = ""
local selectedSlot = nil
local gameFlags = { jewelry_robbery_done = false, has_gold_skin = false }

function Explore.enter(pPlayer, pNodes, pStartNode)
	player = pPlayer
	nodes = pNodes
	currentNode = pStartNode
	eventMessage = ""
	selectedSlot = nil

	-- Initialize Systems
	HUD.init()
	SceneRenderer.init()
	-- Mark starting node as visited
	if player and currentNode and player.visitNode then
		player:visitNode(currentNode.id)
	end
	Explore.loadNodeMinigame()
end

function Explore.loadNodeMinigame()
	currentMinigame = nil
	if currentNode.minigame then
		if currentNode.minigame.type == "click_filler" then
			currentMinigame = ClickFiller.new(currentNode.minigame)
		end
	end
end

function Explore.update(dt)
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
end

function Explore.draw()
	-- 1. Reset Input Zones for this frame
	InputManager.clear()

	-- 2. Draw World
	SceneRenderer.drawBackground(currentNode)

	-- 3. Draw Minigame OR Items/Paths
	if currentMinigame then
		currentMinigame:draw()
	else
		SceneRenderer.drawElements(currentNode)
	end

	-- 4. Draw HUD (Health, Inventory, Messages)
	HUD.draw(player, currentNode, eventMessage, selectedSlot)
end

function Explore.mousepressed(x, y, button)
	if button == 1 then
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

function Explore.enterNode(targetId)
	local prevNode = currentNode
	local targetNode = nodes[targetId]
	local allowed, msg = Events.checkEnter(targetNode, player, gameFlags)

	if not allowed then
		eventMessage = msg or ""
		return
	end

	currentNode = targetNode
	eventMessage = msg or ""
	selectedSlot = nil
	-- Mark the node as visited for tracking
	if player and currentNode and player.visitNode then
		player:visitNode(currentNode.id)
	end

	-- If the player is leaving intersection_1 (node 5) on its first visit
	-- and they did not enter the jewelry store (17), mark the robbery as missed.
	if prevNode and prevNode.id == 5 and gameFlags.jewelry_robbery_pending then
		-- If player hasn't visited jewelry store yet, they missed the robbery
		if not player:hasVisited(17) then
			gameFlags.jewelry_store_missed = true
			gameFlags.jewelry_robbery_done = true
			gameFlags.jewelry_robbery_pending = false
			-- Update jewelry store node to be empty
			if nodes[17] then
				nodes[17].imagePath = "src/data/images/locations/jewelry_store_empty.png"
				nodes[17].description = "The jewelry shop is empty."
				-- Reload the image from the new path
				local success, img = pcall(love.graphics.newImage, nodes[17].imagePath)
				if success then
					nodes[17].image = img
				end
				-- remove any robber/attendant items just in case
				local newItems = {}
				for _, it in ipairs(nodes[17].items or {}) do
					if it.id ~= "robber" and it.id ~= "attendant" then
						table.insert(newItems, it)
					end
				end
				nodes[17].items = newItems
			end
		end
	end
	Explore.loadNodeMinigame()
end

function Explore.pickUp(itemId)
	-- Get selected item ID from inventory slot if one is selected
	local selectedItemId = nil
	if selectedSlot and player.inventory[selectedSlot] then
		selectedItemId = player.inventory[selectedSlot].id
	end

	-- Define items that can only be interacted with, not picked up
	local interactionOnlyItems = {
		["dumpster_fire"] = true,
		["front_door"] = true,
	}

	-- If the item is interaction-only, try to interact with it
	if interactionOnlyItems[itemId] then
		local handled, msg = Interactions.tryInteract(itemId, player, currentNode, gameFlags, selectedItemId)
		if handled then
			eventMessage = msg or ""

			-- Update sketchy_alley description if fire was extinguished
			if gameFlags.sketchy_alley_needs_update and nodes[12] then
				nodes[12].description = "It is a sketchy alley."
				gameFlags.sketchy_alley_needs_update = false
			end

			-- Deselect the item after use
			selectedSlot = nil
		else
			-- Interaction failed, show the message but don't allow pickup
			eventMessage = msg or ""
		end
		return
	end

	-- Try normal interaction for non-pickup-only items
	local handled, msg = Interactions.tryInteract(itemId, player, currentNode, gameFlags, selectedItemId)
	if handled then
		eventMessage = msg or ""

		-- Update sketchy_alley description if fire was extinguished
		if gameFlags.sketchy_alley_needs_update and nodes[12] then
			nodes[12].description = "It is a sketchy alley."
			gameFlags.sketchy_alley_needs_update = false
		end

		-- Deselect the item after use
		selectedSlot = nil

		return
	end

	local itemIndex, itemObj
	for i, item in ipairs(currentNode.items) do
		if item.id == itemId then
			itemIndex = i
			itemObj = item
			break
		end
	end

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
