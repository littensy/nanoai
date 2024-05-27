local activation = require(script.Parent.activation)
local types = require(script.Parent.types)
type Network = types.Network
local predict = require(script.Parent.predict)

local function backpropagate(network: Network, inputs: { number }, expected: { number }, rate: number)
	-- [layer][neuron] = gradient
	local gradients = table.create(network.size)
	local cost = 0

	for i = 1, network.size do
		gradients[i] = {}
	end

	predict(network, inputs)

	-- Calculate the error for the output layer, setting up the gradients for
	-- the preceding layers for backward propagation.
	for i, output in next, network.layers[network.size] do
		local derivative = activation.derivatives[network.activation[network.size]]
		local error = expected[i] - output
		-- Delta for output neurons is the derivative of the activation function
		-- multiplied by the difference between the expected values and the actual
		-- output values.
		gradients[network.size][i] = derivative(output) * error
		cost += error ^ 2
	end

	-- Calculate the error for the hidden layers, propagating the error back
	-- through the network.
	for i = network.size - 1, 1, -1 do
		local derivative = activation.derivatives[network.activation[i]]

		for j, output in next, network.layers[i] do
			local error = 0
			-- For every neuron in the next layer, get the outgoing weights
			-- connected to this neuron and multiply them by the gradient.
			for k, weights in next, network.weights[i + 1] do
				error += weights[j] * gradients[i + 1][k]
			end
			-- Delta for hidden neurons is the derivative of the activation
			-- function multiplied by the sum of the product of the weights
			-- and the gradients of the next layer.
			gradients[i][j] = derivative(output) * error
		end
	end

	-- Adjust the weights and biases of the network based on the calculated
	-- gradients. Weight adjustments are based on the product of the gradient
	-- and the input value, whereas bias adjustments use the gradient alone.
	for i, biases in next, network.biases do
		local previous = network.layers[i - 1] or inputs

		for j, weights in next, network.weights[i] do
			local gradient = gradients[i][j]

			for k, input in next, previous do
				weights[k] += rate * gradient * input
			end

			biases[j] += rate * gradient
		end
	end

	return cost
end

return backpropagate
