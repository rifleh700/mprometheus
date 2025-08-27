local items = {}

function registerMetric(kind, name, description)

	local found = items[name]
	if found then return false end

	items[name] = {
		kind = kind,
		description = description or "",
		values = {}
	}

	return true
end

local function buildLabelsKey(labels)

	if not labels then return "" end
	if not next(labels) then return "" end

	local tokens = {}
	for k, v in pairs(labels) do
		table.insert(tokens, k .. "_" .. v)
	end
	table.sort(tokens)

	return table.concat(tokens, "_")
end

function setMetricValue(kind, name, raw_name, labels, value)

	local data = items[name]
	if not data then
		registerMetric(kind, name)
		data = items[name]
	end

	local raw_name_data = data.values[raw_name]
	if not raw_name_data then
		raw_name_data = {}
		data.values[raw_name] = raw_name_data
	end

	local key = buildLabelsKey(labels)
	local key_data = raw_name_data[key]
	if not key_data then
		key_data = {}
		key_data.labels = labels
		raw_name_data[key] = key_data
	end
	key_data.value = value

	return value
end

function addMetricValue(kind, name, raw_name, labels, value)

	local data = items[name]
	if not data then
		registerMetric(kind, name)
		data = items[name]
	end

	local raw_name_data = data.values[raw_name]
	if not raw_name_data then
		raw_name_data = {}
		data.values[raw_name] = raw_name_data
	end

	local key = buildLabelsKey(labels)
	local key_data = raw_name_data[key]
	if not key_data then
		key_data = {}
		key_data.labels = labels
		key_data.value = 0
		raw_name_data[key] = key_data
	end
	key_data.value = key_data.value + value

	return key_data.value
end

local function serialize_labels(labels)
	if (not labels) or next(labels) == nil then
		return ''
	end

	local parts = {}
	for name, value in pairs(labels) do
		local s = string.format('%s="%s"',
			name, tostring(value))
		table.insert(parts, s)
	end

	local enumerated_via_comma = table.concat(parts, ',')
	return string.format('{%s}', enumerated_via_comma)
end

local function print_metrics()

	local parts = {}
	for name, data in pairs(items) do
		table.insert(parts, string.format("# HELP %s %s", name, data.description))
		table.insert(parts, string.format("# TYPE %s %s", name, data.kind))
		for raw_name, raw_name_data in pairs(data.values) do
			for key, key_data in pairs(raw_name_data) do
				local s = string.format('%s%s %s',
					raw_name,
					serialize_labels(key_data.labels),
					tostring(key_data.value)
				)
				table.insert(parts, s)
			end
		end
	end
	return table.concat(parts, '\n') .. '\n'
end

function metrics()
	return {
		status = 200,
		headers = { ["content-type"] = "text/plain; charset=utf8" },
		body = print_metrics(),
	}
end
