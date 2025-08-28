local INTERVAL = 10000

local function format_bytes(v)

	local postfix = string.sub(v, -3)
	if postfix == " KB" then return tonumber(string.sub(v, 1, -4)) * 1024 end
	if postfix == " MB" then return tonumber(string.sub(v, 1, -4)) * 1024 * 1024 end

	return v
end

local function collectServerInfo(stats)

	removeGauge("server_info")
	setGaugeValue("server_info", 1,
		{
			server_name = getServerName(),
			game_mode = getGameType() or "MTA:SA",
			platform = stats[1][2],
			version = stats[2][2],
			min_client_version = stats[1][6]
		})

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

local function collectCpuUsage(stats)

	local usage, usage_avg = string.match(stats[6][2], "([%d%.]+)%% %(Avg: ([%d%.]+)%%%)")
	setGaugeValue("server_logic_thread_cpu_usage", usage)
	setGaugeValue("server_logic_thread_cpu_usage_avg", usage_avg)

	usage, usage_avg = string.match(stats[7][2], "([%d%.]+)%% %(Avg: ([%d%.]+)%%%)")
	setGaugeValue("server_sync_thread_cpu_usage", usage)
	setGaugeValue("server_sync_thread_cpu_usage_avg", usage_avg)

	usage, usage_avg = string.match(stats[8][2], "([%d%.]+)%% %(Avg: ([%d%.]+)%%%)")
	setGaugeValue("server_raknet_thread_cpu_usage", usage)
	setGaugeValue("server_raknet_thread_cpu_usage_avg", usage_avg)

	return true
end

local function collectMemoryUsage(stats)

	local memory = string.match(stats[5][2], "VM:%d+ MB  RSS:(%d+) MB")
	if not memory then memory = string.match(stats[5][2], "(%d+) MB") end
	setGaugeValue("server_memory_usage_bytes", tonumber(memory) * 1024 * 1024)
	return true
end

local function collectNetwork(stats)

	setGaugeValue("server_network_incoming_bytes", format_bytes(stats[3][4]))
	setGaugeValue("server_network_outgoing_bytes", format_bytes(stats[4][4]))
	setGaugeValue("server_network_incoming_packets", stats[5][4])
	setGaugeValue("server_network_outgoing_packets", stats[6][4])
	setGaugeValue("server_network_outgoing_packets_loss", string.sub(stats[7][4], 1, -3))
	return true
end

local function registerAllServerInfo()

	local columns, stats = getPerformanceStats("Server info")
	registerServerStartTimestamp(stats)
	return true
end

local function collectAllServerInfo()

	local columns, stats = getPerformanceStats("Server info")
	collectServerInfo(stats)
	collectServerFps(stats)
	collectPlayers(stats)
	collectCpuUsage(stats)
	collectMemoryUsage(stats)
	collectNetwork(stats)
	return true
end

registerAllServerInfo()
setTimer(collectAllServerInfo, INTERVAL, 0)