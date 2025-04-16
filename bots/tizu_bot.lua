-- tizu_bot

local move = math.random(1, 3)

return {
	name = "Rockzu",
	func = function(_)
		if math.random() > 0.7 then move = math.random(1, 3) end
		return move
	end
}
