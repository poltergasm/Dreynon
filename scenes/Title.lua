local Rain = require "lib.effects.Rain"
local Scene = require "lib.Scene"
local Baton = require "lib.Baton"
local Button = require "lib.Button"
local Title  = Scene:extends()

local background = love.graphics.newImage("assets/gfx/title.jpg")
local rain

function Title:new(...)
	Title.super.new(self, ...)
	rain = Rain(love.graphics.getWidth(), love.graphics.getHeight(), 150)
	local btn_play = Button(320, 380, "Start Game")
	local btn_quit = Button(320, 390+btn_play.h, "Quit")
	btn_quit.on_click = function() love.event.quit() end
	btn_play.on_click = function() SceneManager:switch("SGame") end

	self.entity_mgr:add(btn_play)
	self.entity_mgr:add(btn_quit)

	self.input = Baton.new {
		["controls"] = {
			["click"] = {'mouse:1'},
			["play"] = {'key:p'},
			["esc"] = {'key:escape'}
		}
	}
end

function Title:on_enter()
	--Song.Title:play()
end

function Title:on_exit()
	Song.Title:stop()
end

function Title:draw_rain()
	 for index, drop in ipairs(rain:getDrops()) do
        -- Get Drop data
        local x1, y1, x2, y2, thick, droplets = drop:get(10)

        -- Draw drop
        love.graphics.setColor(138, 43, 226)
        love.graphics.setLineWidth(thick)
        love.graphics.line(x1, y1, x2, y2)

        if (droplets) then
            for _, droplet in ipairs(droplets) do
                local x, y, radius = droplet:get()
                love.graphics.circle('fill', x, y, radius)
            end
        end

        -- After capturing the current state, update the drop position
        rain:update(drop, index)
    end
end

function Title:update(dt)
	Title.super.update(self, dt)
	self.input:update()

	if self.input:pressed "play" then Song.Title:play() end
end

function Title:draw()
	local w, h = love.graphics.getDimensions()
	local sx, sy = w / background:getWidth(), h / background:getHeight()
	love.graphics.draw(background, 0, 0, 0, math.max(sx,sy))
	self:draw_rain()
	love.graphics.setColor(0, 0, 0, 0.5)
	love.graphics.rectangle("fill", 0, 0, w, h)
	love.graphics.setColor(1, 1, 1, 1)

	println("Dreynon", 320, 100, Font.Title)
	println("The Warlock chronicles", 240, 170, Font.SubTitle)

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

	Title.super.draw(self)
end

return Title