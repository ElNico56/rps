-- rps.lua --

math.randomseed(os.time())
local function printf(f, ...)
	print(string.format(f, ...))
end

ROCK, PAPER, SCISSORS = 1, 2, 3
LOST, TIE, WON = 0, .5, 1
BEATS = {PAPER, SCISSORS, ROCK}

local DEFAULT_ELO = 1200
local K = 512
local ROUNDS = 150000
local BANNED = {rando_bot = true}

local function load_bots()
	local bots = {}
	local handle = assert(io.popen[[dir /b "bots\*_bot.lua"]])
	for file in handle:lines() do
		local name = file:match"(.+_bot)%.lua"
		if name and not BANNED[name] then
			local bot_path = "bots."..name
			local ok, bot_data = pcall(require, bot_path)
			if ok and type(bot_data) == "table" then
				table.insert(bots, {
					name = bot_data.name,
					play = bot_data.func,
					elo = DEFAULT_ELO,
					loses = 0,
					draws = 0,
					wins = 0
				})
			else
				print("Failed to load bot from:", file)
			end
		end
	end
	handle:close()
	return bots
end

local function add_move(moves, me, opp)
	if me == opp then
		moves[#moves+1] = {me = me, opp = opp, outcome = TIE}
	elseif me == BEATS[opp] then
		moves[#moves+1] = {me = me, opp = opp, outcome = WON}
	else
		moves[#moves+1] = {me = me, opp = opp, outcome = LOST}
	end
	if #moves > 100 then table.remove(moves, 1) end
end

local function match(botA, botB, rounds)
	local movesA, movesB = {}, {}
	local scoreA, scoreB = 0, 0
	for _ = 1, rounds do
		local mA = botA.play(movesA)
		local mB = botB.play(movesB)
		add_move(movesA, mA, mB)
		add_move(movesB, mB, mA)
		if mA == mB then
			botA.draws = botA.draws + 1
			botB.draws = botB.draws + 1
			scoreA = scoreA + 0.5
			scoreB = scoreB + 0.5
		elseif mA == BEATS[mB] then
			botA.wins = botA.wins + 1
			botB.loses = botB.loses + 1
			scoreA = scoreA + 1
		else
			botA.loses = botA.loses + 1
			botB.wins = botB.wins + 1
			scoreB = scoreB + 1
		end
	end
	local exA = 1 / (1 + 10 ^ ((botB.elo - botA.elo) / 400))
	local exB = 1 - exA
	botA.elo = botA.elo + K * (scoreA / rounds - exA)
	botB.elo = botB.elo + K * (scoreB / rounds - exB)
	return scoreA - scoreB
end

local function tournament(bots, rounds)
	io.write"BOTS,"
	for _, botA in ipairs(bots) do
		io.write(botA.name, ",")
	end
	io.write"\n"
	for _, botA in ipairs(bots) do
		io.write(botA.name, ",")
		for _, botB in ipairs(bots) do
			io.write(match(botA, botB, rounds), ",")
		end
		io.write"\n"
	end
end

local function main()
	local bots = load_bots()

	tournament(bots, ROUNDS)
	table.sort(bots, function(a, b)
		if arg[1] == "w" then
			return a.wins > b.wins
		elseif arg[1] == "d" then
			return a.draws > b.draws
		elseif arg[1] == "l" then
			return a.loses > b.loses
		end
		return a.elo > b.elo
	end)

	if arg[1] then
		printf("Tournament with %d bots, %d rounds per match\n", #bots, ROUNDS)
		printf("%-15s | %7s | %7s | %7s | %7s",
			"Bot", "WINS", "DRAWS", "LOSES", "ELO")
		print(
			string.rep("-", 15).."-+-"..
			string.rep("-", 7).."-+-"..
			string.rep("-", 7).."-+-"..
			string.rep("-", 7).."-+-"..
			string.rep("-", 7))
		for _, bot in ipairs(bots) do
			printf("%-15s | %7d | %7d | %7d | %7.2f",
				bot.name, bot.wins, bot.draws, bot.loses, bot.elo)
		end
	end
end

main()
