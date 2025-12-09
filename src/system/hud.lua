--[[
	File: hud.lua
	Description: Heads-Up Display (HUD) system for the game.
--]]

local Constants = require("src.constants")
local InputManager = require("src.system.input_manager")
local Utils = require("src.utils")
local VolumeWidget = require("src.system.volume_widget")

local HUD = {}
local uiFont, uiFontSmall, skinImages, itemSprites

-- Returns the appropriate can sprite image based on skin type and current health level (includes damage variants)
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

-- Loads all fonts, can skins (with damage variants), and item sprites for HUD rendering
function HUD.init()
	-- Load fonts safely
	uiFont = Utils.loadFont("src/data/fonts/friz-quadrata-regular.ttf", 24)
	uiFontSmall = Utils.loadFont("src/data/fonts/friz-quadrata-regular.ttf", 16)

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

	-- Load item sprite images
	itemSprites = {
		key_sprite = love.graphics.newImage("src/data/images/sprites/key.png"),
		fire_extinguisher_sprite = love.graphics.newImage("src/data/images/sprites/fire_extinguisher.png"),
		attendant_sprite = love.graphics.newImage("src/data/images/sprites/attendant.png"),
		robber_sprite = love.graphics.newImage("src/data/images/sprites/robber.png"),
		recycling_bin_sprite = love.graphics.newImage("src/data/images/sprites/recycling_bin.png"),
		dumpster_fire_sprite = love.graphics.newImage("src/data/images/sprites/dumpster_fire.png"),
		lock_sprite = love.graphics.newImage("src/data/images/sprites/lock.png"),
	}
end

-- Renders the complete HUD including inventory panel, health display, player sprite, and event messages
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

		-- Draw Item Sprite and Name
		if player.inventory[i] then
			local item = player.inventory[i]

			-- Draw item sprite if available
			if item.spriteId and itemSprites and itemSprites[item.spriteId] then
				local sprite = itemSprites[item.spriteId]
				love.graphics.setColor(1, 1, 1)

				-- Calculate scale to fit sprite in slot (with some padding)
				local maxSize = gui.inv_slot_size - 20
				local spriteW, spriteH = sprite:getDimensions()
				local scale = math.min(maxSize / spriteW, maxSize / spriteH)

				-- Center the sprite in the slot
				local spriteX = bx + gui.inv_slot_size / 2
				local spriteY = by + gui.inv_slot_size / 2 - 5 -- Offset up slightly for name
				love.graphics.draw(sprite, spriteX, spriteY, 0, scale, scale, spriteW / 2, spriteH / 2)
			end

			-- Draw item name below sprite
			love.graphics.setColor(1, 1, 1)
			love.graphics.setFont(love.graphics.newFont(10))
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

	-- SKIN DISPLAY BOX (define position variables first)
	local skinBoxSize = 100
	local sbX = w - 1 - skinBoxSize
	local sbY = 0

	-- Volume button anchored on the cream bar, left of skin box
	local buttonSize = VolumeWidget.getButtonSize()
	local volumeX = sbX - buttonSize - 10
	local volumeY = math.max(2, (40 - buttonSize) / 2)
	VolumeWidget.setAnchor(volumeX, volumeY)

	-- NODE DESCRIPTION (below top bar)
	if currentNode.description then
		love.graphics.setFont(uiFontSmall)
		-- Semi-transparent black background for readability
		local descBoxY = 50
		local descBoxHeight = 50
		local descBoxWidth = sbX - 20 -- End before skin box starts
		love.graphics.setColor(0, 0, 0, 0.7)
		love.graphics.rectangle("fill", 10, descBoxY, descBoxWidth, descBoxHeight)

		-- Draw description text
		love.graphics.setColor(1, 1, 1)
		love.graphics.printf(currentNode.description, 20, descBoxY + 10, descBoxWidth - 20, "left")
	end

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
	love.graphics.setFont(uiFontSmall)
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

	-- 5. Volume control (draw over top bar)
	VolumeWidget.draw()

	-- 6. EVENT MESSAGES
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
