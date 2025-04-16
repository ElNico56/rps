-- tech_bot

return {
	name = "Tech Bot",
	func = function(moves)
		if #moves == 0 then return math.random(1, 3) end
		if #moves == 1 then return math.random(1, 3) end
		local recent = moves[#moves]
		local beforeThat = moves[#moves - 1]
		if recent.outcome == TIE and beforeThat.outcome == TIE then
			if recent.me == beforeThat.me then return BEATS[recent.me] end
		else
			return beforeThat.me
		end
		if recent.outcome == WON or recent.outcome == TIE then return recent.me end
		if recent.outcome == LOST then return BEATS[recent.me] end
	end
}
