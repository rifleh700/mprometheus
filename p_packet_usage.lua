
local INTERVAL = 5000

registerGauge("packet_usage_incoming_messages", "Incoming messages per second")
registerGauge("packet_usage_incoming_bytes", "Incoming bytes per second")
registerGauge("packet_usage_incoming_cpu_usage", "Incoming packets CPU usage")
registerGauge("packet_usage_outgoing_messages", "Outgoing messages per second")
registerGauge("packet_usage_outgoing_bytes", "Outgoing bytes per second")
registerGauge("packet_usage_outgoing_messages_share", "Outgoing messages share")

local packet_types = {}

local function format(v)
	if v == "" then return 0 end
	if v == "-" then return 0 end
	return v
end

local function format_bytes(v)

	if v == "" then return 0 end
	if v == "-" then return 0 end

	local postfix = string.sub(v, -3)
	if postfix == " KB" then return tonumber(string.sub(v, 1, -4)) * 1024 end
	if postfix == " MB" then return tonumber(string.sub(v, 1, -4)) * 1024 * 1024 end

	return v
end

local function format_percent(v)

	if v == "" then return 0 end
	if v == "-" then return 0 end

	return string.sub(v, 1, -2)
end

local function collectPacketUsage()

	for packet_type, _ in ipairs(packet_types) do
		setGaugeValue("packet_usage_incoming_messages", 0, {packet_type = packet_type})
		setGaugeValue("packet_usage_incoming_bytes", 0, {packet_type = packet_type})
		setGaugeValue("packet_usage_incoming_cpu_usage", 0, {packet_type = packet_type})
		setGaugeValue("packet_usage_outgoing_messages", 0, {packet_type = packet_type})
		setGaugeValue("packet_usage_outgoing_bytes", 0, {packet_type = packet_type})
		setGaugeValue("packet_usage_outgoing_messages_share", 0, {packet_type = packet_type})
	end

	local columns, lua_packet_rows = getPerformanceStats("Packet usage")
	for i, data in ipairs(lua_packet_rows) do

		local packet_type = data[1]
		if packet_type == "Sampling... Please wait" then return end

		packet_types[packet_type] = true
		setGaugeValue("packet_usage_incoming_messages", format(data[2]), {packet_type = packet_type})
		setGaugeValue("packet_usage_incoming_bytes", format_bytes(data[3]), {packet_type = packet_type})
		setGaugeValue("packet_usage_incoming_cpu_usage", format_percent(data[4]), { packet_type = packet_type})
		setGaugeValue("packet_usage_outgoing_messages", format(data[5]), {packet_type = packet_type})
		setGaugeValue("packet_usage_outgoing_bytes", format_bytes(data[6]), {packet_type = packet_type})
		setGaugeValue("packet_usage_outgoing_messages_share", format_percent(data[7]), { packet_type = packet_type})
	end

	return true
end

setTimer(collectPacketUsage, INTERVAL, 0)