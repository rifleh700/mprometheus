
local INTERVAL = 10000

local function registerServerInfo(stats)

	setGaugeValue("server_info", 1, {platform = stats[1][2], version = stats[2][2], min_client_version = stats[1][6]})
	return true
end

local function registerServerStartTimestamp(stats)

	local days, hours, mins = string.match(stats[4][2], "(%d+) Days (%d+) Hours (%d+) Mins")
	local current_timestamp = getRealTime().timestamp
	local start_timestamp = current_timestamp - (tonumber(mins) * 60) - (tonumber(hours) * 60 * 60) - (tonumber(days) * 60 * 60 * 24)
	setGaugeValue("server_start_timestamp", start_timestamp)
	return true
end

local function collectServerFps(stats)

	local fps, fps_logic = string.match(stats[1][4], "(%d+) %((%d+)%)")
	setGaugeValue("server_fps_sync", fps)
	setGaugeValue("server_fps_sync_logic", fps_logic)
	return true
end

local function collectPlayers(stats)

	local players, players_limit = string.match(stats[2][4], "(%d+) / (%d+)")
	setGaugeValue("server_players_total", players)
	setGaugeValue("server_players_limit", players_limit)
	return true
end

local function registerAllServerInfo()

	local columns, stats = getPerformanceStats("Server info")
	registerServerInfo(stats)
	registerServerStartTimestamp(stats)
	return true
end

local function collectAllServerInfo()

	local columns, stats = getPerformanceStats("Server info")
	collectServerFps(stats)
	collectPlayers(stats)
	return true
end

registerAllServerInfo()
setTimer(collectAllServerInfo, INTERVAL, 0)