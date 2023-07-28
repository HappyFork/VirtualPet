class_name State # Base class of all states
extends Node


# Variables
var state_machine = null # The state machine controlling this state
var controlled_object = null # The owner of the state machine


# Virtual function corresponding to _process()
func update( _delta: float ) -> void:
	pass

# Virtual function corresponding to _physics_process()
func physics_update( _delta: float ) -> void:
	pass

# Called by the state machine when it changes to this state
func enter( _msg := {} ) -> void:
	pass

# Called by the state machine when it chages from this state to another one
func exit() -> void:
	pass
