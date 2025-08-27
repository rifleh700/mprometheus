local INTERVAL = 10000

registerGauge("event_packet_usage_messages")

local packets = {}

local function collectEventPacketUsage()

	for key, data in pairs(packets) do
		setGaugeValue("event_packet_usage_messages", 0, { packet_type = data.packet_type, packet_name = data.packet_name })
	end

	local columns, event_packet_usage_rows = getPerformanceStats("Event Packet usage")
	for i, data in ipairs(event_packet_usage_rows) do
		local packet_type = data[1]
		local packet_name = data[2]
		packets[packet_type .. ":" .. packet_name] = { packet_type = packet_type, packet_name = packet_name }
		setGaugeValue("event_packet_usage_messages", data[3], { packet_type = packet_type, packet_name = packet_name })
	end

	return true
end

setTimer(collectEventPacketUsage, INTERVAL, 0)