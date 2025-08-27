local INTERVAL = 5000

registerGauge("lua_timing_cpu_usage", "CPU usage in the last 5 seconds")
registerGauge("lua_timing_cpu_time", "CPU time spent in last 5 seconds")

local resources = {}

local function format(v)
	if v == "" then return 0 end
	if v == "-" then return 0 end
	return v
end

local function format_percent(v)

	if v == "" then return 0 end
	if v == "-" then return 0 end

	return string.sub(v, 1, -2)
end

local function collectLuaTiming()

	for resource_name, _ in pairs(resources) do
		setGaugeValue("lua_timing_cpu_usage", 0, { resource = resource_name })
		setGaugeValue("lua_timing_cpu_time", 0, { resource = resource_name })
	end

	local columns, lua_timing_rows = getPerformanceStats("Lua timing")
	for i, data in ipairs(lua_timing_rows) do
		local resource_name = data[1]
		resources[resource_name] = true
		setGaugeValue("lua_timing_cpu_usage", format_percent(data[2]), { resource = resource_name })
		setGaugeValue("lua_timing_cpu_time", format(data[3]), { resource = resource_name })
	end

	return true
end

setTimer(collectLuaTiming, INTERVAL, 0)