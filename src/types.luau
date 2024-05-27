export type Thenable = {
	andThen: (self: Thenable, resolved: ((...any) -> ())?, rejected: ((unknown) -> ())?) -> Thenable,
}

export type Network = {
	size: number,
	-- [layer] = size (including input layer)
	shape: { number },
	-- [layer][neuron] = state
	layers: { { number } },
	-- [layer][neuron][prevNeuron] = weight
	weights: { { { number } } },
	-- [layer][neuron] = bias
	biases: { { number } },
	-- [layer] = activation()
	activation: { string },
}

return nil
