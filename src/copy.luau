local function copy<T>(object: T): T
	if type(object) == "table" then
		local clone = table.clone(object)

		for key, value in next, clone do
			clone[key] = copy(value)
		end

		return clone :: any
	end

	return object
end

return copy
