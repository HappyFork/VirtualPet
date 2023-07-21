class_name StateMachine # Is this necessary?
extends Node
# This code was adapted from the GDQuest finite state machine tutorial available at
# https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/


# Variables & Signals
@export var initial_state : NodePath
@onready var state: State = get_node( initial_state )
@onready var sm_owner = get_parent()
signal transitioned( state_name )


# Functions
func _ready():
	await sm_owner.ready
	for child in get_children():
		child.state_machine = self
	state.enter()

func _process(delta):
	state.update( delta )

func _physics_process(delta):
	state.physics_update( delta )

func transition_to( target_state_path: String, msg: Dictionary = {} ) -> void:
	assert( has_node( target_state_path ) )
	state.exit()
	state = get_node( target_state_path )
	state.enter( msg )
	emit_signal( "transitioned", state.name )
