-- addi_Bot

return {
	name = "ADDI Bot",
	func = function(moves)
		local count = 0
		for x = 1, #moves do
			count = count + moves[x].opp
		end
		return count % 3 + 1
	end
}
