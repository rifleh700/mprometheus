local KIND = "counter"

function registerCounter(name, description)

	return registerMetric(KIND, name, description)
end

function addCounterValue(name, value, labels)

	return addMetricValue(KIND, name, name, labels, value)
end

function setCounterValue(name, value, labels)

	return setMetricValue(KIND, name, name, labels, value)
end