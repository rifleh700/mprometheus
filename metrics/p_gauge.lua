local KIND = "gauge"

function registerGauge(name, description)

	return registerMetric(KIND, name, description)
end

function setGaugeValue(name, value, labels)

	return setMetricValue(KIND, name, name, labels, value)
end