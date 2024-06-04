--[=[
	Creates a deep copy of the given object. Can be used to clone a neural
	network, since networks are JSON encodable.

	@param object The object to clone.
	@return A deep copy of the object.
]=]
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
