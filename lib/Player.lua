local Player = {}

function Player:new()
	self.x = 50
	self.y = 50
	self.stats = {
		max_health = 50,
		health 	   = 50,
		max_mana   = 25,
		mana       = 25
	}
	self.in_town = false
	self.credits = 15
	return self
end

function Player:move_player(dir)
	if dir == "north" then
		self.y = self.y - 1
	elseif dir == "east" then
		self.x = self.x + 1
	elseif dir == "south" then
		self.y = self.y + 1
	elseif dir == "west" then
		self.x = self.x - 1
	end
end

return Player