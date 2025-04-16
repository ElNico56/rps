-- nico_bot

return {
	name = "Nico Bot",
	func = function(moves)
		if #moves == 0 then return math.random(1, 3) end
		return BEATS[moves[#moves].opp]
	end
}
