local Town = require "lib.Town"
local Cresbrook = Town:extends()

function Cresbrook:new(...)
	Cresbrook.super.new(self, ...)

	self.image = love.graphics.newImage("assets/gfx/towns/cresbrook.jpg")

	self:add_npc({
		["name"] = "Adrian Johnson",
		["dialog"] = {
			"Now that you've spoken with Derrick, I can finally",
			"send you on your way. But first, please take these",
			"credits so you can fit yourself out with some armor.",
			"You should check out Byron's Booty. Good luck."
		},
		["gives"] = {
			{ "credits", 25 }
		},
		["requires"] = {
			{ "speak_to", "Derrick Harth"}
		},
		["dialog2"] = {
			"Have you visited Byron's Booty for some gear yet?"
		}
	})

	self:add_npc({
		["name"] = "Derrick Harth",
		["dialog"] = {
			"Hey, so you're finally awake. Yeah, I get it, you're ",
			"probably wondering who I am. The more important ",
			"question you should be asking yourself ",
			"is who you are ...",
			"You're a Warlock. Although human in appearance, you're",
			"infact a rare species, gifted with the ability to ",
			"create, and manipulate dark matter."
		}
	})

	self:add_npc({
		["name"] = "Kira O'Reilly",
		["dialog"] = {
			{
				"Uh.. yeah, hi."
			}
		}
	})
end

return Cresbrook