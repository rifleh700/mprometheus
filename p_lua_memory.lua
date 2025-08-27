
local INTERVAL = 5000

registerGauge("lua_memory_usage", "Current memory usage")
registerGauge("lua_memory_events_total", "How many event created")
registerGauge("lua_memory_timers_total", "How many timers the resource is using")
registerGauge("lua_memory_elements_total", "How many elements created")

local resources = {}

local function format(v)
	if v == "" then return 0 end
	if v == "-" then return 0 end
	return v
end

local function format_bytes(value)

	if v == "" then return 0 end
	if v == "-" then return 0 end

	local postfix = string.sub(value, -3)
	if postfix == " KB" then return tonumber(string.sub(value, 1, -4)) * 1024 end
	if postfix == " MB" then return tonumber(string.sub(value, 1, -4)) * 1024 * 1024 end
	return string.sub(v, 1, -2)
end

local function collectLuaMemory()

	for resource_name, _ in pairs(resources) do
		setGaugeValue("lua_memory_usage", 0, {resource = resource_name})
		setGaugeValue("lua_memory_events_total", 0, {resource = resource_name})
		setGaugeValue("lua_memory_timers_total", 0, {resource = resource_name})
		setGaugeValue("lua_memory_elements_total", 0, {resource = resource_name})
	end

	local columns, lua_memory_rows = getPerformanceStats("Lua memory")
	for i, data in ipairs(lua_memory_rows) do
		local resource_name = data[1]
		if resource_name ~= "" then
			resources[resource_name] = true
			setGaugeValue("lua_memory_usage", format_bytes(data[3]), {resource = resource_name})
			setGaugeValue("lua_memory_events_total", format(data[7]), {resource = resource_name})
			setGaugeValue("lua_memory_timers_total", format(data[8]), {resource = resource_name})
			setGaugeValue("lua_memory_elements_total", format(data[9]), {resource = resource_name})
		end
	end

	return true
end

setTimer(collectLuaMemory, INTERVAL, 0)