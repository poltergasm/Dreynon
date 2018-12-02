local Throttle = require "lib.Throttle"
require "lib.Utils"

Player = require("lib.Player"):new()
Color = require "lib.Palette"
SceneManager = require "lib.SceneManager"
Canvas 	= love.graphics.newCanvas(900, 800)
Font = {
	["Main"] = love.graphics.newFont("assets/fonts/coolvetica.ttf", 20),
	["Button"] = love.graphics.newFont("assets/fonts/bebasneue.ttf", 32),
	["Title"] = love.graphics.newFont("assets/fonts/ringbarer.ttf", 52),
	["SubTitle"] = love.graphics.newFont("assets/fonts/ringbarer.ttf", 32),
	["Label"] = love.graphics.newFont("assets/fonts/ringbarer.ttf", 20)
}

Song = {
	["Title"] = love.audio.newSource("assets/audio/bgm/berbe.ogg", "stream"),
	["Town"]  = love.audio.newSource("assets/audio/bgm/town.ogg", "stream")
}

Sound = {
	["Click"] = love.audio.newSource("assets/audio/sfx/click.wav", "static")
}

function println(s, x, y, f, c)
	if f ~= nil then
		love.graphics.setFont(f)
	else
		love.graphics.setFont(Font.Main)
	end
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.print(s, x+2, y+2)
	local color = c ~= nil and c or Color.Clear
	love.graphics.setColor(color)
	love.graphics.print(s, x, y)
	if c then love.graphics.setColor(Color.Clear) end
end

scaleX, scaleY = 0, 0
cursor = love.mouse.newCursor("assets/gfx/cursor.png")

function love.load()
	Throttle:init(60)
	Canvas:setFilter("nearest", "nearest")
	love.window.setTitle("Dreynon")
	love.window.setMode(900, 800)
	love.graphics.setFont(Font.Main)
	love.mouse.setCursor(cursor)
	-- set volumes
	Song.Title:setVolume(0.3)
	--Sound.Click:setVolume(0.5)
	
	SceneManager:add({
		["STitle"] = require "scenes.Title"(),
		["SGame"]  = require "scenes.Game"()
	})
	SceneManager:switch("STitle")
end

function love.update(dt)
	Throttle:update()
	SceneManager:update(dt)
end

function love.draw()
	love.graphics.setCanvas(Canvas)
	SceneManager:draw()
	love.graphics.setCanvas()
	local screenW,screenH = love.graphics.getDimensions()
	local canvasW,canvasH = Canvas:getDimensions()
	scaleX = love.graphics.getWidth() / canvasW
	scaleY = love.graphics.getHeight() / canvasH
	love.graphics.draw(Canvas, 0, 0, 0, scaleX, scaleY)

	Throttle:draw()
end