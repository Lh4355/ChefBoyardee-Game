-- src/states/explore.lua
local Constants = require("src.constants")
local Utils = require("src.utils")
local Events = require("src.system.events")
local Interactions = require("src.system.interactions")

local Explore = {}

-- These will be passed in from main.lua
local player, nodes, currentNode
local clickZones = {}
local eventMessage = ""
local selectedSlot = nil -- NEW: Tracks the currently selected inventory slot
local gameFlags = { jewelry_robbery_done = false, has_gold_skin = false }

function Explore.enter(pPlayer, pNodes, pStartNode)
	player = pPlayer
	nodes = pNodes
	currentNode = pStartNode
	eventMessage = ""
	selectedSlot = nil -- Reset selection when entering exploration
end

function Explore.update(dt)
	if player.health <= 0 then
		return "gameover"
	end
end

function Explore.draw()
	clickZones = {} -- Reset click zones for this frame

	-- 1. Draw Background (Fixed Scaling)
	if currentNode.image then
		local windowWidth = love.graphics.getWidth()
		local windowHeight = love.graphics.getHeight()
		local imageWidth = currentNode.image:getWidth()
		local imageHeight = currentNode.image:getHeight()

		local scaleX = windowWidth / imageWidth
		local scaleY = windowHeight / imageHeight

		love.graphics.draw(currentNode.image, 0, 0, 0, scaleX, scaleY)
	end

	-- 2. Draw Text (Description)
	love.graphics.setColor(1, 1, 1)
	love.graphics.printf(currentNode.description, 50, 50, 700, "left")

	-- Draw Event Message (Yellow)
	if eventMessage ~= "" then
		love.graphics.setColor(1, 1, 0)
		love.graphics.printf(eventMessage, 50, 100, 700, "left")
	end

	-- 3. Draw Items (Clickable)
	for i, item in ipairs(currentNode.items) do
		local ix, iy = item.x or (100 + i * 60), item.y or 400
		local iw, ih = item.w or Constants.GUI.item_scene_size, item.h or Constants.GUI.item_scene_size

		if item.id == "attendant" then
			love.graphics.setColor(0, 1, 0)
		else
			love.graphics.setColor(0, 0, 1)
		end

		love.graphics.rectangle("fill", ix, iy, iw, ih)
		love.graphics.setColor(1, 1, 1)
		love.graphics.print(item.name, ix, iy - 20)

		table.insert(clickZones, { x = ix, y = iy, w = iw, h = ih, type = "item", id = item.id })
	end

	-- 4. Draw Paths
	local y = 200
	love.graphics.setColor(1, 1, 1)
	for pathName, targetId in pairs(currentNode.paths) do
		local txt = "Go to " .. pathName
		love.graphics.print(txt, 50, y)
		local font = love.graphics.getFont()
		table.insert(
			clickZones,
			{ x = 50, y = y, w = font:getWidth(txt), h = font:getHeight(), type = "path", targetId = targetId }
		)
		y = y + 30
	end

	-- 5. Draw HUD (Health & Inventory)
	love.graphics.setColor(0.3, 0.3, 0.3)
	love.graphics.rectangle("fill", 50, 10, 200, 20)
	love.graphics.setColor(1, 0, 0)
	love.graphics.rectangle("fill", 50, 10, player.health * 2, 20)
	love.graphics.setColor(1, 1, 1)
	love.graphics.print("Health: " .. player.health .. "%", 260, 12)
	love.graphics.print("Skin: " .. player.skin, 400, 12)

	-- NEW: Draw Description ABOVE inventory if selected, otherwise show title
	if selectedSlot and player.inventory[selectedSlot] then
		local item = player.inventory[selectedSlot]
		love.graphics.setColor(1, 1, 0) -- Yellow text for description
		-- Print description slightly higher than the title was
		love.graphics.printf(item.description, Constants.GUI.inv_start_x, Constants.GUI.inv_start_y - 45, 700, "left")
	else
		love.graphics.setColor(1, 1, 1)
		love.graphics.print("INVENTORY", Constants.GUI.inv_start_x, Constants.GUI.inv_start_y - 25)
	end

	for i = 1, 8 do
		local bx = Constants.GUI.inv_start_x + (i - 1) * (Constants.GUI.inv_slot_size + Constants.GUI.inv_padding)

		-- Highlight the box if it is the selected slot
		if i == selectedSlot then
			love.graphics.setColor(1, 1, 0) -- Yellow border
		else
			love.graphics.setColor(1, 1, 1) -- White border
		end

		love.graphics.rectangle(
			"line",
			bx,
			Constants.GUI.inv_start_y,
			Constants.GUI.inv_slot_size,
			Constants.GUI.inv_slot_size
		)

		if player.inventory[i] then
			love.graphics.setColor(1, 1, 1) -- Reset to white for text
			love.graphics.printf(
				player.inventory[i].name,
				bx,
				Constants.GUI.inv_start_y + 15,
				Constants.GUI.inv_slot_size,
				"center"
			)
		end

		-- NEW: Add inventory slot to clickZones so mousepressed can see it
		table.insert(clickZones, {
			x = bx,
			y = Constants.GUI.inv_start_y,
			w = Constants.GUI.inv_slot_size,
			h = Constants.GUI.inv_slot_size,
			type = "inventory",
			slotIndex = i,
		})
	end
end

function Explore.mousepressed(x, y, button)
	if button == 1 then
		for _, zone in ipairs(clickZones) do
			if Utils.checkCollision(x, y, 1, 1, zone.x, zone.y, zone.w, zone.h) then
				if zone.type == "item" then
					Explore.pickUp(zone.id)
				elseif zone.type == "path" then
					Explore.enterNode(zone.targetId)
				-- NEW: Handle Inventory Clicks
				elseif zone.type == "inventory" then
					if player.inventory[zone.slotIndex] then
						selectedSlot = zone.slotIndex
					else
						selectedSlot = nil -- Deselect if clicking empty slot
					end
				end
				return
			end
		end
        
		-- If the loop finishes without hitting any buttons/items:
		-- selectedSlot = nil
	end
end

function Explore.enterNode(targetId)
	local targetNode = nodes[targetId]
	local allowed, msg = Events.checkEnter(targetNode, player, gameFlags)

	if not allowed then
		eventMessage = msg or ""
		return
	end

	currentNode = targetNode
	eventMessage = msg or ""
	selectedSlot = nil -- Optional: Deselect item when moving to a new room?
end

function Explore.pickUp(itemId)
	local handled, msg = Interactions.tryInteract(itemId, player, currentNode, gameFlags)
	if handled then
		eventMessage = msg or ""
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
			eventMessage = "Picked up: " .. itemObj.name -- Show confirmation on screen
		else
			eventMessage = "Inventory Full!"
		end
	end
end

return Explore
