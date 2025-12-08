-- src/system/hud.lua
local Constants = require("src.constants")
local InputManager = require("src.system.input_manager")

local HUD = {}
local uiFont, uiFontSmall, skinImages

-- Pick the correct can sprite based on skin and health buckets
local function selectSkinImage(skin, health)
	local h = math.max(0, math.floor(health or 0))
	local variant

	if h <= 25 then
		variant = "destroyed"
	elseif h <= 49 then
		variant = "dented_4"
	elseif h <= 69 then
		variant = "dented_3"
	elseif h <= 84 then
		variant = "dented_2"
	elseif h <= 95 then
		variant = "dented_1"
	end

	local key = variant and (skin .. "_" .. variant) or skin
	return (skinImages and skinImages[key]) or (skinImages and skinImages[skin])
end

function HUD.init()
	-- Load fonts safely
	local success, font = pcall(love.graphics.newFont, "src/data/fonts/friz-quadrata-regular.ttf", 24)
	if success then
		uiFont = font
	else
		uiFont = love.graphics.newFont(24)
	end

	local successSmall, fontSmall = pcall(love.graphics.newFont, "src/data/fonts/friz-quadrata-regular.ttf", 16)
	if successSmall then
		uiFontSmall = fontSmall
	else
		uiFontSmall = love.graphics.newFont(16)
	end

	-- Load skin images
	skinImages = {
		tin = love.graphics.newImage("src/data/images/sprites/can_tin.png"),
		tin_dented_1 = love.graphics.newImage("src/data/images/sprites/can_tin_dented_1.png"),
		tin_dented_2 = love.graphics.newImage("src/data/images/sprites/can_tin_dented_2.png"),
		tin_dented_3 = love.graphics.newImage("src/data/images/sprites/can_tin_dented_3.png"),
		tin_dented_4 = love.graphics.newImage("src/data/images/sprites/can_tin_dented_4.png"),
		tin_destroyed = love.graphics.newImage("src/data/images/sprites/can_tin_destroyed.png"),

		gold = love.graphics.newImage("src/data/images/sprites/can_gold.png"),
		gold_dented_1 = love.graphics.newImage("src/data/images/sprites/can_gold_dented_1.png"),
		gold_dented_2 = love.graphics.newImage("src/data/images/sprites/can_gold_dented_2.png"),
		gold_dented_3 = love.graphics.newImage("src/data/images/sprites/can_gold_dented_3.png"),
		gold_dented_4 = love.graphics.newImage("src/data/images/sprites/can_gold_dented_4.png"),
		gold_destroyed = love.graphics.newImage("src/data/images/sprites/can_gold_destroyed.png"),

		-- Add more skins below as needed
	}
end

function HUD.draw(player, currentNode, eventMessage, selectedSlot)
	local w, h = love.graphics.getDimensions()
	local gui = Constants.GUI

	-- Ensure fonts and sprites are loaded
	if not uiFont or not skinImages then
		HUD.init()
	end

	-- 1. BOTTOM GREEN PANEL (Inventory)
	local panelY = h - gui.inv_panel_height
	love.graphics.setColor(unpack(gui.COLORS.green_panel))
	love.graphics.rectangle("fill", 0, panelY, w, gui.inv_panel_height)

	-- Inventory Label
	love.graphics.setColor(unpack(gui.COLORS.cream)) -- Reddish Text
	love.graphics.setFont(uiFontSmall)
	love.graphics.print("Inventory", 240, panelY + 5)

	-- Draw Slots (Inventory Boxes)
	for i = 1, 8 do
		local bx = gui.inv_start_x + (i - 1) * (gui.inv_slot_size + gui.inv_padding)
		local by = panelY + 30

		-- Draw Slot Border
		love.graphics.setLineWidth(3)
		if i == selectedSlot then
			love.graphics.setColor(1, 1, 0) -- Yellow if selected
		else
			love.graphics.setColor(unpack(gui.COLORS.cream)) -- Red otherwise
		end
		love.graphics.rectangle("line", bx, by, gui.inv_slot_size, gui.inv_slot_size)

		-- Draw Slot Number
		love.graphics.setColor(1, 1, 1, 0.5)
		love.graphics.print(tostring(i), bx + 2, by + 2)

		-- Draw Item Name
		if player.inventory[i] then
			love.graphics.setColor(1, 1, 1)
			love.graphics.setFont(love.graphics.newFont(10))
			love.graphics.printf(player.inventory[i].name, bx, by + 15, gui.inv_slot_size, "center")
		end

		-- REGISTER CLICK ZONE
		InputManager.register(bx, by, gui.inv_slot_size, gui.inv_slot_size, "inventory", i)
	end

	-- Description Text
	love.graphics.setFont(uiFont)
	if selectedSlot and player.inventory[selectedSlot] then
		love.graphics.setColor(1, 1, 1)
		love.graphics.printf(player.inventory[selectedSlot].description, 550, panelY + 25, 230, "left")
	else
		love.graphics.setColor(1, 1, 1, 0.5)
		love.graphics.printf("Select item for info", 550, panelY + 25, 230, "left")
	end

	-- TOP Bar -------------------------------------

	-- Background
	love.graphics.setColor(unpack(gui.COLORS.cream))
	love.graphics.rectangle("fill", 0, 0, 800, 40)

	-- Health Background Bar
	love.graphics.setColor(unpack(gui.COLORS.grey))
	love.graphics.rectangle("fill", 10, 10, 150, 20)

	-- Health Fill Bar
	love.graphics.setColor(unpack(gui.COLORS.red))
	local healthWidth = (player.health / 100) * 150
	love.graphics.rectangle("fill", 10, 10, healthWidth, 20)

	-- Health Border
	love.graphics.setColor(0, 0, 0)
	love.graphics.setLineWidth(2)
	love.graphics.rectangle("line", 10, 10, 150, 20)

	-- Health Text
	love.graphics.setColor(unpack(gui.COLORS.red))
	love.graphics.setFont(uiFontSmall)
	love.graphics.print("Health: " .. player.health .. "%", 170, 13)

	-- NODE NAME (top center)
	local nodeName = currentNode.name:upper()
	love.graphics.setColor(0, 0, 0)
	love.graphics.printf(nodeName, 0, 15, w, "center")

	-- SKIN DISPLAY BOX
	local skinBoxSize = 100
	local sbX = w - 1 - skinBoxSize
	local sbY = 0

	love.graphics.setColor(unpack(gui.COLORS.grey))
	love.graphics.rectangle("fill", sbX, sbY, skinBoxSize, skinBoxSize)

	love.graphics.setColor(unpack(gui.COLORS.green_panel))
	love.graphics.setLineWidth(4)
	love.graphics.rectangle("line", sbX, sbY, skinBoxSize, skinBoxSize)

	love.graphics.setColor(unpack(gui.COLORS.grey))
	love.graphics.rectangle("fill", sbX, sbY + skinBoxSize, skinBoxSize, 20)

	love.graphics.setColor(unpack(gui.COLORS.green_panel))
	love.graphics.setLineWidth(4)
	love.graphics.rectangle("line", sbX, sbY + skinBoxSize, skinBoxSize, 20)

	love.graphics.setColor(unpack(gui.COLORS.green_panel))
	-- love.graphics.setFont(love.graphics.newFont(10))
	love.graphics.newFont("src/data/fonts/friz-quadrata-regular.ttf", 1)
	love.graphics.print("Skin: " .. player.skin, sbX + 5, sbY + skinBoxSize + 5)

	-- Draw skin image (health-aware denting)
	local skinImage = selectSkinImage(player.skin, player.health)
	if skinImage then
		love.graphics.setColor(1, 1, 1)
		-- Draw image centered in the box, scaled to fit
		local scale = (skinBoxSize - 10) / math.max(skinImage:getDimensions())
		local ix = skinImage:getWidth()
		local iy = skinImage:getHeight()
		love.graphics.draw(skinImage, sbX + skinBoxSize / 2, sbY + skinBoxSize / 2, 0, scale, scale, ix / 2, iy / 2)
	else
		-- Fallback if image not found
		love.graphics.setColor(0.8, 0, 0)
		love.graphics.circle("fill", sbX + 30, sbY + 30, 15)
	end

	-- 5. EVENT MESSAGES
	if eventMessage ~= "" then
		local msgW = uiFont:getWidth(eventMessage)
		love.graphics.setColor(0, 0, 0, 0.8)
		love.graphics.rectangle("fill", w / 2 - msgW / 2 - 10, panelY - 40, msgW + 20, 30)

		love.graphics.setColor(unpack(gui.COLORS.text_yellow))
		love.graphics.printf(eventMessage, 0, panelY - 35, w, "center")
	end

	love.graphics.setColor(1, 1, 1, 1) -- Reset
end

return HUD
