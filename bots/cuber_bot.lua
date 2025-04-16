-- cuber_bot

return {
	name = "Cuber Bot",
	func = function(moves)
		local counts = {0, 0, 0}
		local popular_move = math.random(1, 3)

		for _, move in ipairs(moves) do
			counts[move.opp] = counts[move.opp] + 1
			if counts[move.opp] >= counts[popular_move] then
				popular_move = move.opp
			end
		end
		return BEATS[popular_move]
	end
}
