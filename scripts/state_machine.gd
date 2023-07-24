class_name StateMachine # Is this necessary?
extends Node
# This code was adapted from the GDQuest finite state machine tutorial available at
# https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/


# Variables & Signals
@export var initial_state : NodePath
@export var wander_x_min : float = -1100
@export var wander_x_max : float = 1600
@export var wander_y_min : float = -800
@export var wander_y_max : float = 900
@onready var state: State
@onready var sm_owner = get_parent()
signal transitioned( state_name )


# Engine Functions
func _ready(): # When the state machine enters a scene tree
	await sm_owner.ready # Wait until the machine owner is ready
	for child in get_children(): # For each state (child of this node),
		child.state_machine = self # Let it know this is the state machine.
		child.controlled_object = sm_owner # Let it know who the owner is.
	randomize() # Make random numbers used later really random
	state.enter() # Run enter on the initial state.
	call_deferred( "first_decision" ) # Make the first decision.
		# This is deferred because the NavigationServer needs physics data.

func _process(delta): # Every frame
	state.update( delta )

func _physics_process(delta): # Every physics frame
	state.physics_update( delta )


# Custom functions
func first_decision():
	sm_owner.survey()
	await get_tree().physics_frame
	decide_next_action()

func decide_next_action(): # Decide what to do next
	print( "Deciding..." )
	var decision = randi_range( 0, 2 ) # Randomly choose between wait, wander, and eat
	
	match decision:
		0: # Wait
			print( "I want to wait" )
			transition_to( "Idle" )
		1: # Wander
			print( "I want to wander" )
			var x = randf_range( wander_x_min, wander_x_max )
			var y = randf_range( wander_y_min, wander_y_max )
			var msg = {
				"goal": "wander",
				"x": x,
				"y": y
			}
			transition_to( "Walking", msg )
		2: # Eat
			pass

func transition_to( target_state_path: String, msg: Dictionary = {} ) -> void:
	# Transition to the passed-in state.
	assert( has_node( target_state_path ) ) # Make sure it exists
	state.exit() # Run old state's exit code
	state = get_node( target_state_path ) # Change states
	state.enter( msg ) # Run new state's enter code
	emit_signal( "transitioned", state.name ) # Emit transitioned signal
