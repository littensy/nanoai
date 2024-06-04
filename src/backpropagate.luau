local activation = require(script.Parent.activation)
local types = require(script.Parent.types)
type Network = types.Network
local predict = require(script.Parent.predict)

--[=[
	Adjusts the weights and biases of the network to minimize the error between
	the output signal and the target signal. The learning rate determines how
	much the weights and biases are adjusted.

	For efficient optimization, you must run an initialization function before
	training the network. The `init` namespace contains a collection of
	initialization functions.
	
	@param network The neural network.
	@param input The input signal.
	@param target The expected output.
	@param learningRate The rate at which weights and biases are adjusted.
]=]
local function backpropagate(network: Network, inputs: { number }, target: { number }, learningRate: number)
	local output = predict(network, inputs)
	local deltas = table.create(network.size)

	-- Calculate the deltas for each neuron in the network. The deltas are used
	-- to adjust the weights and biases of the network in the next step.
	for i = network.size, 1, -1 do
		local derivative = activation.derivatives[network.activation[i]]

		deltas[i] = table.create(network.shape[i])

		-- In the output layer, the delta for each neuron is the derivative of the
		-- activation function multiplied by the derivative of the cost function.
		if i == network.size then
			for j, neuron in next, output do
				deltas[i][j] = derivative(neuron) * (target[j] - neuron)
			end

			continue
		end

		-- In the hidden layers, the delta for each neuron is the derivative of the
		-- activation function multiplied by the weighted sum of the deltas from
		-- the next layer.
		for j, neuron in next, network.layers[i] do
			local error = 0

			for k, weights in next, network.weights[i + 1] do
				error += weights[j] * deltas[i + 1][k]
			end

			deltas[i][j] = derivative(neuron) * error
		end
	end

	-- Adjust the weights and biases of the network based on the calculated
	-- deltas. Weight adjustments are based on the product of the delta and
	-- the input value, whereas bias adjustments use the delta alone.
	for i, biases in next, network.biases do
		local inputLayer = network.layers[i - 1] or inputs

		for j, weights in next, network.weights[i] do
			local delta = deltas[i][j]

			for k, input in next, inputLayer do
				weights[k] += learningRate * delta * input
			end

			biases[j] += learningRate * delta
		end
	end
end

return backpropagate
