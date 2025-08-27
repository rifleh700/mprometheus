
local INTERVAL = 5000

registerGauge("process_memory_usage_bytes", "Breakdown of the process memory usage")

local function collectProcessMemoryStats()

	local stats = getProcessMemoryStats()
	setGaugeValue("process_memory_usage_bytes", stats.virtual, { memory = "virtual"})
	setGaugeValue("process_memory_usage_bytes", stats.resident, { memory = "resident"})
	setGaugeValue("process_memory_usage_bytes", stats.shared, { memory = "shared"})
	setGaugeValue("process_memory_usage_bytes", stats.private, { memory = "private"})
	return true
end

setTimer(collectProcessMemoryStats, INTERVAL, 0)