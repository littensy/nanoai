export type Activation = "Sigmoid" | "TanH" | "ArcTan" | "SoftPlus" | "Linear" | "ReLU" | "LeakyReLU" | "ELU"

local Activation = {
	Sigmoid = "Sigmoid",
	TanH = "TanH",
	ArcTan = "ArcTan",
	SoftPlus = "SoftPlus",
	Linear = "Linear",
	ReLU = "ReLU",
	LeakyReLU = "LeakyReLU",
	ELU = "ELU",
}

local functions = {
	[Activation.Sigmoid] = function(x: number): number
		return 1 / (1 + math.exp(-x))
	end,

	[Activation.TanH] = math.tanh,

	[Activation.ArcTan] = math.atan,

	[Activation.SoftPlus] = function(y: number): number
		return math.log(math.exp(y) + 1)
	end,

	[Activation.Linear] = function(x: number): number
		return x
	end,

	[Activation.ReLU] = function(x: number): number
		return math.max(0, x)
	end,

	[Activation.LeakyReLU] = function(x: number): number
		return math.max(0.01 * x, x)
	end,

	[Activation.ELU] = function(x: number): number
		return x < 0 and 2 * (math.exp(x) - 1) or x
	end,
}

local derivatives = {
	[Activation.Sigmoid] = function(y: number): number
		return y * (1 - y)
	end,

	[Activation.TanH] = function(y: number): number
		return 1 - y ^ 2
	end,

	[Activation.ArcTan] = function(y: number): number
		return 1 / (math.tan(y) ^ 2 + 1)
	end,

	[Activation.SoftPlus] = function(y: number): number
		return 1 / (1 + 1 / (math.exp(y) - 1))
	end,

	[Activation.Linear] = function(): number
		return 1
	end,

	[Activation.ReLU] = function(y: number): number
		return y > 0 and 1 or 0
	end,

	[Activation.LeakyReLU] = function(y: number): number
		return y > 0 and 1 or 0.01
	end,

	[Activation.ELU] = function(y: number): number
		return y < 0 and y + 2 or 1
	end,
}

return {
	Activation = Activation,
	functions = functions,
	derivatives = derivatives,
}
