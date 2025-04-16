-- azure_bot

return {
	name = "Azure Bot",
	func = function(moves)
		if #moves == 0 then
			return math.random(1, 3)
		end
		local last_move = moves[#moves]
		if last_move.outcome == TIE then
			return last_move.me
		elseif last_move.outcome == LOST then
			return last_move.opp
		else
			return BEATS[last_move.opp]
		end
	end
}
