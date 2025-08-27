
local INTERVAL = 30000

local function collectResourcesState()

	local running = 0
	local failed = 0
	for resource_name, resource in pairs(getResources()) do
		local state = getResourceState(resource)
		running = running + (state == "running" and 1 or 0)
		failed = failed + (state == "failed to load" and 1 or 0)
	end
	setGaugeValue("resources_running_total", running)
	setGaugeValue("resources_failed_total", failed)
	return true
end

setTimer(collectResourcesState, INTERVAL, 0)