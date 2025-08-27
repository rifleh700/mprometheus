local KIND = "summary"

function registerSummary(name, description)

	return registerMetric(KIND, name, description)
end

function addSummaryValue(name, value, labels)

	addMetricValue(KIND, name, name .. "_count", labels, 1)
	return addMetricValue(KIND, name, name .. "_sum", labels, value)
end