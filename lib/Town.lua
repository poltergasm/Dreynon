local Class = require "lib.Class"
local Town = Class:extends()

function Town:new(name, x, y)
	assert(y ~= nil, "Town requires at least a name, x, and y co-ordinate")
	self.name = name
	self.x = x
	self.y = y
	self.discovered = false
	self.npcs = {}
end

function Town:add_npc(o)
	o.id = #self.npcs+1
	o.spoken_to = false
	self.npcs[o.name] = o
end

function Town:talk_to(id)
	Player.talk_to = self.npcs[id]
end

return Town