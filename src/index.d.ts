export as namespace Nanoai;
export = Nanoai;

declare namespace Nanoai {
	enum Activation {
		Sigmoid = "Sigmoid",
		TanH = "TanH",
		ArcTan = "ArcTan",
		SoftPlus = "SoftPlus",
		Linear = "Linear",
		ReLU = "ReLU",
		LeakyReLU = "LeakyReLU",
		ELU = "ELU",
	}

	/**
	 * A multi-layer perceptron neural network model.
	 */
	interface Network {
		/**
		 * The total amount of layers in the network, excluding the input layer.
		 */
		size: number;
		/**
		 * The shape of the network, where each element represents the amount of
		 * neurons in that layer. The first element is the input layer, the last
		 * element is the output layer, and the rest are hidden layers.
		 */
		shape: number[];
		/**
		 * A 2D array containing the signals of each neuron in each layer.
		 */
		layers: number[][];
		/**
		 * A 3D array containing the weights of each connection between neurons.
		 */
		weights: number[][][];
		/**
		 * A 2D array containing the biases of each neuron in each layer.
		 */
		biases: number[][];
		/**
		 * The activation functions of each layer, excluding the input layer.
		 */
		activation: Activation[];
	}

	/**
	 * Creates a new neural network with the specified shape and activation
	 * functions. The shape is an array of numbers, where each element represents
	 * the amount of neurons in that layer.
	 *
	 * @param shape The shape of the network.
	 * @param activation The activation functions of each layer.
	 *
	 * @returns A new neural network.
	 */
	function create(shape: number[], activation: Activation | Activation[]): Network;

	/**
	 * Feeds the input signal through the network and returns the output signal.
	 *
	 * @param network The neural network.
	 * @param input The input signal.
	 *
	 * @returns The output signal.
	 */
	function predict(network: Network, input: number[]): number[];

	/**
	 * Adjusts the weights and biases of the network to minimize the error between
	 * the output signal and the target signal. Returns the error of the network.
	 *
	 * Note that for efficient optimization, the network should be randomized
	 * with the `init` functions before calling this function.
	 *
	 * @param network The neural network.
	 * @param input The input signal.
	 * @param expected The expected output.
	 * @param learningRate The learning rate.
	 *
	 * @returns The error of the network.
	 */
	function backpropagate(network: Network, input: number[], expected: number[], learningRate: number): number;

	/**
	 * Creates a deep copy of the given object. Can be used to clone a neural
	 * network model.
	 *
	 * @param object The object to clone.
	 *
	 * @returns A deep copy of the object.
	 */
	function clone<T>(object: T): T;

	/**
	 * Calls the `initializer` for each weight and bias in the network. If the
	 * `initializer` returns `undefined`, the weight or bias will not be changed.
	 *
	 * The `initializer` receives the layer index and the neuron index. If the
	 * function is adjusting a weight, it will also receive the previous neuron
	 * index. Otherwise, it will receive `-1`.
	 *
	 * @param network The neural network.
	 * @param initializer The initializer function.
	 *
	 * @returns The neural network.
	 */
	function initialize(
		network: Network,
		initializer: (layer: number, neuron: number, prevNeuron: number | -1) => number | void,
	): Network;

	/**
	 * A collection of initialization functions to prepare a neural network for
	 * optimization.
	 */
	namespace init {
		function zeros(network: Network): Network;
		function ones(network: Network): Network;
		function constant(network: Network, value: number): Network;
		function uniform(network: Network, min?: number, max?: number): Network;
		function normal(network: Network, mean?: number, std?: number): Network;
		function xavierNormal(network: Network): Network;
		function xavierUniform(network: Network): Network;
	}

	interface Agent {
		network: Network;
		fitness: number;
	}

	interface GeneticAlgorithmOptions {
		/**
		 * The base neural network model. Only the shape and activation functions
		 * are preserved.
		 */
		network: Network;
		/**
		 * The amount of agents to spawn in each epoch.
		 */
		population: number;
		/**
		 * The amount of epochs to run the genetic algorithm.
		 * @default 100
		 */
		epochs?: number;
		/**
		 * The maximum amount a weight or bias can be adjusted during mutation.
		 * @default 0.1
		 */
		mutation?: number;
		/**
		 * Evaluate and calculate the fitness of a unique agent in the population.
		 * If the function returns a promise, the genetic algorithm will run all
		 * agents in parallel.
		 */
		spawn: (network: Network, index: number) => Promise<number> | number;
		/**
		 * Evaluate the population after each epoch. If the function returns
		 * `true`, the genetic algorithm will stop.
		 */
		done?: (epoch: number, agents: Agent[]) => boolean | void;
	}

	/**
	 * Runs a genetic algorithm to evolve the neural network to minimize the
	 * error between the output signal and the target signal.
	 *
	 * Calls the `spawn` function to assess the fitness of each agent in the
	 * population, where `spawn` should return a fitness score for the agent.
	 * If `spawn` returns a promise, the genetic algorithm will run all agents
	 * in parallel.
	 *
	 * @param options The genetic algorithm options.
	 *
	 * @returns Each agent in the population sorted by fitness.
	 */
	function evolution(options: GeneticAlgorithmOptions): Agent[];
}
