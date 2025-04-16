-- teto_bot

return {
	name = "Teto Bot",
	func = function(moves)
		if #moves == 0 then return math.random(1, 3) end
		if #moves == 1 then return BEATS[moves[#moves].opp] end
		local LUT = {
			{PAPER,    ROCK,     SCISSORS},
			{ROCK,     SCISSORS, PAPER},
			{SCISSORS, PAPER,    ROCK},
		}
		local move1 = moves[#moves].opp
		local move2 = moves[#moves - 1].opp
		return LUT[move2][move1]
	end
}
