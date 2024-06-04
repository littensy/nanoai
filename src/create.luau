local types = require(script.Parent.types)
type Network = types.Network

--[=[
	Creates a new neural network with the specified shape and activation
	functions. The shape is an array of numbers, where each element represents
	the amount of neurons in that layer.
	
	@param shape The shape of the network.
	@param activation The activation functions of each layer.
	@return A new neural network.
]=]
local function create(shape: { number }, activation: string | { string }): Network
	local width = #shape - 1
	local layers = table.move(shape, 2, width + 1, 1, {})

	local network: Network = {
		size = width,
		shape = shape,
		layers = table.create(width),
		weights = table.create(width),
		biases = table.create(width),
		activation = if type(activation) == "table" then activation else table.create(width, activation),
	}

	for i, size in next, layers do
		network.layers[i] = table.create(size, 0)
		network.biases[i] = table.create(size, 0)
		network.weights[i] = table.create(size)

		for j = 1, size do
			network.weights[i][j] = table.create(shape[i], 0)
		end
	end

	return network
end

return create
