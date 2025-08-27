local INTERVAL = 5000

registerCounter("network_received_bytes", "Total number of bytes received since the connection was started")
registerCounter("network_sent_bytes", "Total number of bytes sent since the connection was started")
registerCounter("network_received_packets", "Total number of packets received since the connection was started")
registerCounter("network_sent_packets", "Total number of packets sent since the connection was started")
registerGauge("network_packet_loss_total", "Total packet loss percentage of sent data, since the connection was started")
registerGauge("network_packet_loss_last_second", "Packet loss percentage of sent data, during the previous second")
registerGauge("network_send_buffer_messages")
registerGauge("network_resend_buffer_messages", "Number of packets queued to be resent (due to packet loss)")

local function collectNetworkStats()

	local stats = getNetworkStats()
	setCounterValue("network_received_bytes", stats.bytesReceived)
	setCounterValue("network_sent_bytes", stats.bytesSent)
	setCounterValue("network_received_packets", stats.packetsReceived)
	setCounterValue("network_sent_packets", stats.packetsSent)
	setGaugeValue("network_packet_loss_total", stats.packetlossTotal)
	setGaugeValue("network_packet_loss_last_second", stats.packetlossLastSecond)
	setGaugeValue("network_send_buffer_messages", stats.messagesInSendBuffer)
	setGaugeValue("network_resend_buffer_messages", stats.messagesInResendBuffer)
	return true
end

setTimer(collectNetworkStats, INTERVAL, 0)