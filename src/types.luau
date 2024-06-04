--[=[
	The neural network model, containing the neurons, weights, biases, and
	activation functions of the network. The network is JSON encodable, so
	it is safe to serialize and send over a remote event.
]=]
export type Network = {
	--[=[
		The total amount of layers in the network, excluding the input layer.
	]=]
	size: number,
	--[=[
		The shape of the network, where each element represents the amount of
		neurons in that layer. The first element is the input layer, the last
		element is the output layer, and the rest are hidden layers.
	]=]
	shape: { number },
	--[=[
		A 2D array containing the signals of each neuron in each layer. Keyed by
		the layer index and the neuron index.
	]=]
	layers: { { number } },
	--[=[
		A 3D array containing the weights of each connection between neurons.
		Keyed by the layer index, the neuron itself, and the previous neuron.
	]=]
	weights: { { { number } } },
	--[=[
		A 2D array containing the biases of each neuron in each layer. Keyed by
		the layer index and the neuron index.
	]=]
	biases: { { number } },
	--[=[
		The activation functions of each layer after the input layer. Keyed by
		the index of the layer.
	]=]
	activation: { string },
}

return nil
