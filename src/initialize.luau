local Activation = require(script.Parent.activation).Activation
local types = require(script.Parent.types)
type Network = types.Network

local DEFAULT_GAIN = {
	[Activation.TanH] = 5 / 3,
	[Activation.ReLU] = 2 ^ 0.5,
	[Activation.LeakyReLU] = (2 / 1.01) ^ 0.5,
}

local function initialize(network: Network, initializer: (number, number, number) -> number?)
	for i, weights in next, network.weights do
		for j, neuron in next, weights do
			for k in next, neuron do
				neuron[k] = initializer(i, j, k) or neuron[k]
			end
		end
	end

	for i, biases in next, network.biases do
		for j in next, biases do
			biases[j] = initializer(i, j, -1) or biases[j]
		end
	end

	return network
end

local function gaussian(mean: number, std: number): number
	-- Perform a Box-Muller transform to convert two uniform random numbers
	-- into a single Gaussian-distributed random number.
	local u = 1 - math.random() -- Converting [0, 1) to (0, 1)
	local v = math.random()
	local z = (-2 * math.log(u)) ^ 0.5 * math.cos(2 * math.pi * v)
	return mean + std * z
end

local init = {
	zeros = function(network: Network)
		return initialize(network, function()
			return 0
		end)
	end,

	ones = function(network: Network)
		return initialize(network, function()
			return 1
		end)
	end,

	constant = function(network: Network, value: number)
		return initialize(network, function()
			return value
		end)
	end,

	uniform = function(network: Network, min: number?, max: number?)
		min = min or 0
		max = max or 1
		assert(min and max, "Type assertion failed")

		return initialize(network, function()
			return math.random() * (max - min) + min
		end)
	end,

	normal = function(network: Network, mean: number?, std: number?)
		mean = mean or 0
		std = std or 1
		assert(mean and std, "Type assertion failed")

		return initialize(network, function()
			return gaussian(mean, std)
		end)
	end,

	xavierNormal = function(network: Network)
		return initialize(network, function(layer, _, prevNeuron)
			if prevNeuron == -1 then
				return -- Skip biases
			end

			local fanIn = network.shape[layer]
			local fanOut = network.shape[layer + 1]
			local gain = DEFAULT_GAIN[network.activation[layer]] or 1
			local std = gain * (2 / (fanIn + fanOut)) ^ 0.5

			return gaussian(0, std)
		end)
	end,

	xavierUniform = function(network: Network)
		return initialize(network, function(layer, _, prevNeuron)
			if prevNeuron == -1 then
				return -- Skip biases
			end

			local fanIn = network.shape[layer]
			local fanOut = network.shape[layer + 1]
			local gain = DEFAULT_GAIN[network.activation[layer]] or 1
			local range = gain * (6 / (fanIn + fanOut)) ^ 0.5

			return 2 * math.random() * range - range
		end)
	end,
}

return {
	initialize = initialize,
	init = init,
}
