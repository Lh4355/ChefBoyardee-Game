-- main.lua
local Node = require("src.node")
local Item = require("src.item")
local Player = require("src.player")
local Menu = require("src.menu")
local map_nodes_data = require("src.data.map_nodes")
local Events = require("src.events")
local Interactions = require("src.interactions")

-- Define these at the top with "local" so they are seen by the whole file
local nodes = {}
local currentNode
local gamestate
local player

-- GLOBAL FLAGS (Passed to events/interactions)
local gameFlags = {
	jewelry_robbery_done = false,
	has_gold_skin = false,
}

-- GUI CONFIGURATION (Day 3)
local GUI = {
	inv_slot_size = 50, -- Size of the inventory boxes
	inv_padding = 10, -- Space between boxes
	inv_start_x = 50, -- Starting X position
	inv_start_y = 500, -- Starting Y position (Bottom of a 600px screen)
	item_scene_size = 40, -- Size of the "item" squares in the world
}

-- MOUSE INTERACTION STORAGE
-- We'll clear this every frame in love.draw and populate it with clickable areas
local clickZones = {}
local eventMessage = "" -- To show text like "The robber trips on you!"

function love.load()
	io.stdout:setvbuf("no")
	print("------------------------------------------------")
	print("LOADING NODES...")

	-- Iterate through the raw data and create Node objects
	-- Load Nodes
	for id, data in ipairs(map_nodes_data) do
		local newNode = Node.new(data.id, data.name or "Unnamed", data.description, data.imagePath)
		nodes[id] = newNode

		if data.imagePath then
			-- Safety wrapper for image loading
			local status, err = pcall(function()
				newNode.image = love.graphics.newImage(data.imagePath)
			end)

			if not status then
				print("Error loading image for node " .. id .. ": " .. err)
			end
		end

		newNode.paths = data.paths
		-- Important: Ensure items table exists
		newNode.items = newNode.items or {}
	end
	print("------------------------------------------------")
	print("NODES LOADED SUCCESSFULLY")

	-- PLAYER SETUP
	player = Player.new("Chef Can", 400, 300)

	-- STARTING STATE
	currentNode = nodes[1]
	gamestate = "menu"

	-- TEST ITEM SETUP (Day 3)
	local testItem = Item.new("rusty_key", "Rusty Key", "An old key.", "gfx_key")
	testItem.x = 400
	testItem.y = 400
	testItem.w = GUI.item_scene_size
	testItem.h = GUI.item_scene_size

	table.insert(nodes[1].items, testItem)
	print("DEBUG: Added Rusty Key to Node 1 at (400, 400)")
end

-- HELPER: Simple AABB Collision Detection
function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
	return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

-- REFACTORED: EnterNode delegates to src/events.lua
function EnterNode(targetId)
    -- 1. Get the actual Node object first (This contains the .items table!)
    local targetNode = nodes[targetId]

    -- 2. Check Events / Locks (Pass targetNode, NOT just targetId)
    local allowed, msg = Events.checkEnter(targetNode, player, gameFlags)

    -- 3. Handle Result
    if not allowed then
        -- If blocked, stay here and show the "Locked" message
        eventMessage = msg
        return
    end

    -- 4. Move Player
    currentNode = targetNode

    -- 5. Set Message (if the event returned one, like "Robber crashes!")
    eventMessage = msg
end

-- INVENTORY LOGIC: PickUp delegates to src/interactions.lua
function PickUp(itemId)
	-- 1. Check Custom Interactions (Attendant, etc.)
	local handled, msg = Interactions.tryInteract(itemId, player, currentNode, gameFlags)
	if handled then
		eventMessage = msg or ""
		return
	end

	-- 2. Standard Pickup Logic
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
			print("Picked up: " .. itemObj.name)
		else
			eventMessage = "Inventory Full!"
		end
	end
end

function love.update(dt)
	if gamestate == "menu" then
		Menu.update(dt)
	elseif gamestate == "explore" and player.health <= 0 then
		gamestate = "gameover"
	end
end

-- MOUSE CLICK LOGIC
function love.mousepressed(x, y, button)
	if gamestate == "explore" and button == 1 then
		for _, zone in ipairs(clickZones) do
			if CheckCollision(x, y, 1, 1, zone.x, zone.y, zone.w, zone.h) then
				if zone.type == "item" then
					PickUp(zone.id)
				elseif zone.type == "path" then
					EnterNode(zone.targetId)
				end
				return
			end
		end
	elseif gamestate == "menu" then
		if Menu.mousepressed(x, y, button) == "explore" then
			gamestate = "explore"
		end
	end
end

-- KEYBOARD LOGIC
function love.keypressed(key)
	if gamestate == "menu" then
		if Menu.keypressed(key) == "explore" then
			gamestate = "explore"
		end
	elseif gamestate == "explore" then
		local n = tonumber(key)
		if n and n >= 1 and n <= 8 and player.inventory[n] then
			eventMessage = "Inspecting: " .. player.inventory[n].description
		end
		if key == "d" then
			player:takeDamage(10)
		end
	elseif gamestate == "gameover" and key == "r" then
		love.load()
	end
end

function love.draw()
    clickZones = {} -- Reset click zones for this frame

    if gamestate == "explore" then
        -- 1. Draw Background (Fixed Scaling)
        if currentNode.image then
            local windowWidth = love.graphics.getWidth()
            local windowHeight = love.graphics.getHeight()
            local imageWidth = currentNode.image:getWidth()
            local imageHeight = currentNode.image:getHeight()
            
            -- Calculate scale factors to fit the window exactly
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
            local ix, iy = item.x or (100 + i*60), item.y or 400
            local iw, ih = item.w or GUI.item_scene_size, item.h or GUI.item_scene_size
            
            -- Color code: NPCs (Attendant) are Green, Items are Blue
            if item.id == "attendant" then 
                love.graphics.setColor(0, 1, 0) 
            else 
                love.graphics.setColor(0, 0, 1) 
            end
            
            love.graphics.rectangle("fill", ix, iy, iw, ih)
            love.graphics.setColor(1, 1, 1)
            love.graphics.print(item.name, ix, iy - 20)
            
            table.insert(clickZones, {x=ix, y=iy, w=iw, h=ih, type="item", id=item.id})
        end

        -- 4. Draw Paths
        local y = 200
        love.graphics.setColor(1, 1, 1)
        for pathName, targetId in pairs(currentNode.paths) do
            local txt = "Go to " .. pathName
            love.graphics.print(txt, 50, y)
            local font = love.graphics.getFont()
            table.insert(clickZones, {x=50, y=y, w=font:getWidth(txt), h=font:getHeight(), type="path", targetId=targetId})
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
        
        love.graphics.print("INVENTORY", GUI.inv_start_x, GUI.inv_start_y - 25)
        for i = 1, 8 do
            local bx = GUI.inv_start_x + (i - 1) * (GUI.inv_slot_size + GUI.inv_padding)
            love.graphics.rectangle("line", bx, GUI.inv_start_y, GUI.inv_slot_size, GUI.inv_slot_size)
            if player.inventory[i] then
                love.graphics.printf(player.inventory[i].name, bx, GUI.inv_start_y + 15, GUI.inv_slot_size, "center")
            end
        end

    elseif gamestate == "menu" then
        Menu.draw()
    elseif gamestate == "gameover" then
        love.graphics.clear(0, 0, 0)
        love.graphics.setColor(1, 0, 0)
        love.graphics.printf("YOU ARE EXPIRED (GAME OVER)", 0, 250, 800, "center")
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Press 'R' to Restart", 0, 300, 800, "center")
    end
    
    love.graphics.setColor(1, 1, 1)
end
