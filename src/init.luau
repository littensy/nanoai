local activation = require("./activation")
local backpropagate = require("./backpropagate")
local copy = require("./copy")
local create = require("./create")
local evolution = require("./evolution")
local init = require("./initializers")
local initialize = require("./initialize")
local predict = require("./predict")
local types = require("./types")

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
