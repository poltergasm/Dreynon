local Cresbrook = require "lib.towns.Cresbrook"
local Button = require "lib.Button"
local Baton  = require "lib.Baton"
local Scene = require "lib.Scene"
local Game  = Scene:extends()

function Game:new(...)
	Game.super.new(self, ...)

	local btn_north = Button(40, 75, "North")
	local btn_east  = Button(86, 75+btn_north.h, "East")
	local btn_south = Button(40, btn_east.y+btn_east.h, "South")
	local btn_west  = Button(10, btn_east.y, "West")

	btn_north.on_click = function() Player:move_player("north") end
	btn_east.on_click = function() Player:move_player("east") end
	btn_south.on_click = function() Player:move_player("south") end
	btn_west.on_click = function() Player:move_player("west") end

	self.entity_mgr:add(btn_north)
	self.entity_mgr:add(btn_east)
	self.entity_mgr:add(btn_south)
	self.entity_mgr:add(btn_west)

	self.input = Baton.new {
		["controls"] = {
			["click"] = {'mouse:1'},
			["play"] = {'key:p'},
			["esc"] = {'key:escape'}
		}
	}

	self.towns = {
		Cresbrook = Cresbrook("Cresbrook", 50, 50)
	}

	local btn_back = Button(600, 50, "Back")
	self.btn_back = btn_back
	self.btn_back.on_click = function()
		Player.talk_to = false
		self.btn_back.hidden = true
	end
	self.btn_back.hidden = true
	self.entity_mgr:add(self.btn_back)

	self:check_location()
end

function Game:on_enter()
end

function Game:check_location()
	if Player.x == 50 and Player.y == 50 then
		Player.in_town = self.towns.Cresbrook
	end
end

function Game:draw_top_bar()
	println("Dreynon", 10, 4, Font.SubTitle)
end

function Game:draw_left_panel()
	love.graphics.setColor(Color.Purple)
	love.graphics.rectangle("fill", 0, 50, 200, 750)
	love.graphics.setColor(Color.Clear)

	-- position
	println("Position: " .. Player.x .. ", " .. Player.y, 20, 250)
	
end

function Game:draw_right_panel()
	love.graphics.setColor(Color.Pink)
	love.graphics.rectangle("fill", 700, 50, 200, 750)
	love.graphics.setColor(Color.Clear)

	println("Inventory", 720, 70, Font.Label)
	println("Credits: " .. Player.credits, 720, 110)
end

function Game:draw_body()
	if Player.talk_to then
		println(Player.talk_to.name, 210, 60, Font.Button, Color.Green)

		local show_dialog = true
		local x, y = 210, 120
		if Player.talk_to.requires then
			for _, v in pairs (Player.talk_to.requires) do
				if v[1] == "speak_to" then
					local speak_to = Player.in_town.npcs[v[2]]
					if not speak_to.spoken_to then
						println("You should speak with " .. speak_to.name .. " first", x, y)
						show_dialog = false
					end
				end
			end
		end

		if show_dialog then
			for _,v in pairs(Player.talk_to.dialog) do
				println(v, x, y)
				y = y + 30
			end
		end

		Player.talk_to.spoken_to = true
		self.btn_back.hidden = false

	elseif Player.in_town then
		-- draw image
		love.graphics.draw(Player.in_town.image, 200, 50)
		love.graphics.setColor(0, 0, 0, 0.7)
		love.graphics.rectangle("fill", 200, 50, 500, 50)
		love.graphics.setColor(Color.Clear)
		println("Welcome to " .. Player.in_town.name, 210, 60, Font.Button)

		println("You see", 210, 340, Font.Label)

		local x, y = 210, 370
		local mx, my = love.mouse.getPosition()
		for _,v in pairs(Player.in_town.npcs) do
			local btnw = Font.Main:getWidth(v.name)
			local btnh = Font.Main:getHeight(v.name)
			if mx >= x*scaleX and mx <= (x+btnw)*scaleX and my >= y*scaleY and my <= (y+btnh)*scaleY then
				if self.input:pressed "click" then
					Sound.Click:stop()
					Sound.Click:play()
					Player.in_town:talk_to(v.name)
				end
				println(v.name, 210, y, nil)
			else
				println(v.name, 210, y, nil, Color.Green)
			end
			y = y + 30
		end
	else
		println("You are no where", 210, 75)
	end
end

function Game:draw_hud()
	self:draw_top_bar()
	self:draw_left_panel()
	self:draw_right_panel()
	self:draw_body()
end

function Game:update(dt)
	Game.super.update(self, dt)
	self.input:update()
end

function Game:draw()
	love.graphics.clear(Color.Black)
	self:draw_hud()
	Game.super.draw(self)

	local mx, my = love.mouse.getPosition()
	for _,v in pairs(self.entity_mgr.entities) do
		if mx >= v.x*scaleX and mx <= (v.x+v.w)*scaleX and my >= v.y*scaleY and my <= (v.y+v.h)*scaleY then
			love.graphics.setColor(Color.Blue)
			love.graphics.rectangle("fill", v.x-1, v.y-1, v.w+1, v.h+1)
			love.graphics.setColor(Color.Clear)
			if self.input:pressed "click" then
				Sound.Click:stop()
				Sound.Click:play()
				if v.on_click ~= nil then
					v:on_click()
				end
			end
		end
	end
end

return Game