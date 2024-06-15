local activation = require(script.activation)
local backpropagate = require(script.backpropagate)
local copy = require(script.copy)
local create = require(script.create)
local evolution = require(script.evolution)
local init = require(script.initializers)
local initialize = require(script.initialize)
local predict = require(script.predict)
local types = require(script.types)

export type Network = types.Network
export type Activation = activation.Activation
export type Agent = evolution.Agent

return {
	Activation = activation.Activation,
	backpropagate = backpropagate,
	clone = copy,
	create = create,
	evolution = evolution,
	init = init,
	initialize = initialize,
	predict = predict,
}
