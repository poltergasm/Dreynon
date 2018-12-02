local Class = require "lib.Class"
local Button = Class:extends()

function Button:new(x, y, label, c)
	assert(label ~= nil, "Button arguments (x, y, label)")
	local fontW
	self.x = x
	self.y = y
	self.w = Font.Button:getWidth(label)+22
	self.h = Font.Button:getHeight(label)+10
	self.label = label
	self.c = c and c or {1, 1, 1, 1}
	self.hidden = false
end

function Button:update(dt) end

function Button:draw()
	love.graphics.setColor(0, 0, 0, 0.6)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.setFont(Font.Button)
	love.graphics.print(self.label, self.x+12, self.y+7)
	love.graphics.setColor(self.c)
	love.graphics.print(self.label, self.x+10, self.y+5)
	love.graphics.setFont(Font.Main)
end

return Button