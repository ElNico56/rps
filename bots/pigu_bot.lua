-- pigu_bot

return {
	name = "Pigu Bot",
	func = function(moves)
		if #moves == 0 then return math.random(1, 3) end
		return moves[#moves].opp
	end
}
