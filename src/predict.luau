local activation = require(script.Parent.activation)
local types = require(script.Parent.types)
type Network = types.Network

--[=[
	Feeds the input signal through the network and returns the output signal.
	
	@param network The neural network.
	@param input The input signal.
	@return The output signal.
]=]
local function predict(network: Network, inputs: { number }): { number }
	local previous = inputs

	for i, layer in next, network.layers do
		local activation = activation.functions[network.activation[i]]

		for j, bias in next, network.biases[i] do
			local sum = bias

			for k, weight in next, network.weights[i][j] do
				sum += weight * previous[k]
			end

			layer[j] = activation(sum)
		end

		previous = layer
	end

	return network.layers[network.size]
end

return predict
