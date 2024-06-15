local types = require(script.Parent.types)
type Network = types.Network

export type Filter = "weights" | "biases" | "all"

--[=[
	Calls the `initializer` for each weight and bias in the network. If the
	`initializer` returns `undefined`, the weight or bias will not be changed.

	The `initializer` receives the layer index and the neuron index. If the
	function is adjusting a weight, it will also receive the previous neuron
	index. Otherwise, it will receive `-1`.
	
	@param network The neural network.
	@param initializer The initializer function.
	@param filter The target of the initializer. Defaults to `"all"`.
	@return The neural network.
]=]
local function initialize(
	network: Network,
	initializer: (number, number, number) -> number | false?,
	filter: Filter?
): Network
	filter = filter or "all"

	if filter == "weights" or filter == "all" then
		for i, weights in next, network.weights do
			for j, neuron in next, weights do
				for k in next, neuron do
					neuron[k] = initializer(i, j, k) or neuron[k]
				end
			end
		end
	end

	if filter == "biases" or filter == "all" then
		for i, biases in next, network.biases do
			for j in next, biases do
				biases[j] = initializer(i, j, -1) or biases[j]
			end
		end
	end

	return network
end

return initialize
