local Activation = require(script.Parent.activation).Activation
local initialize = require(script.Parent.initialize)
type Filter = initialize.Filter
local types = require(script.Parent.types)
type Network = types.Network

local DEFAULT_GAIN = {
	[Activation.TanH] = 5 / 3,
	[Activation.ReLU] = 2 ^ 0.5,
	[Activation.LeakyReLU] = (2 / 1.01) ^ 0.5,
}

--[=[
	Perform a Box-Muller transform to convert two uniform random numbers into a
	single Gaussian-distributed random number.

	@param mean The mean of the distribution.
	@param std The standard deviation of the distribution.
	@return A normally-distributed random number.
]=]
local function gaussian(mean: number, std: number): number
	local u = 1 - math.random() -- Converting [0, 1) to (0, 1)
	local v = math.random()
	local z = (-2 * math.log(u)) ^ 0.5 * math.cos(2 * math.pi * v)

	return mean + std * z
end

--[=[
	A collection of initialization functions to prepare a neural network for
	optimization.
]=]
return {
	zeros = function(network: Network, filter: Filter?)
		return initialize(network, function()
			return 0
		end, filter)
	end,

	ones = function(network: Network, filter: Filter?)
		return initialize(network, function()
			return 1
		end, filter)
	end,

	constant = function(network: Network, value: number, filter: Filter?)
		return initialize(network, function()
			return value
		end, filter)
	end,

	uniform = function(network: Network, min: number?, max: number?, filter: Filter?)
		min = min or 0
		max = max or 1
		assert(min and max, "Luau")

		return initialize(network, function()
			return math.random() * (max - min) + min
		end, filter)
	end,

	normal = function(network: Network, mean: number?, std: number?, filter: Filter?)
		mean = mean or 0
		std = std or 1
		assert(mean and std, "Luau")

		return initialize(network, function()
			return gaussian(mean, std)
		end, filter)
	end,

	xavierNormal = function(network: Network, gain: number?)
		return initialize(network, function(layer)
			local scale = gain or DEFAULT_GAIN[network.activation[layer]] or 1
			local fanIn = network.shape[layer]
			local fanOut = network.shape[layer + 1]

			return gaussian(0, scale * (2 / (fanIn + fanOut)) ^ 0.5)
		end, "weights")
	end,

	xavierUniform = function(network: Network, gain: number?)
		return initialize(network, function(layer)
			local scale = gain or DEFAULT_GAIN[network.activation[layer]] or 1
			local fanIn = network.shape[layer]
			local fanOut = network.shape[layer + 1]
			local range = scale * (6 / (fanIn + fanOut)) ^ 0.5

			return math.random() * 2 * range - range
		end, "weights")
	end,
}
