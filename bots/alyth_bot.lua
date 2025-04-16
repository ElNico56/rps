-- alyth_bot

return {
	name = "Alyth Bot",
	func = function(moves)
		if #moves == 0 then return math.random(1, 3) end
		return BEATS[BEATS[moves[#moves].opp]]
	end
}
