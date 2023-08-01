class_name StateMachine # Is this necessary?
extends Node
# This code was adapted from the GDQuest finite state machine tutorial available at
# https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/


# Variables & Signals
@export var initial_state : NodePath # The state the machine starts in (idle)
@export var wander_x_min : float = -1100 # The range of random points
@export var wander_x_max : float = 1600 # where the pet can wander
@export var wander_y_min : float = -800 # if it chooses to
@export var wander_y_max : float = 900

@onready var state: State = get_node( initial_state ) # The machine's current state
@onready var sm_owner = get_parent() # The pet that owns the machine

signal transitioned( state_name ) # Change states


# Engine Functions
func _ready(): # When the state machine enters a scene tree
	await sm_owner.ready # Wait until the machine owner is ready
	for child in get_children(): # For each state (child of this node),
		child.state_machine = self # Let it know this is the state machine.
		child.controlled_object = sm_owner # Let it know who the owner is.
	randomize() # Make random numbers used later really random
	state.enter() # Run enter on the initial state.

func _process(delta): # Every frame
	if state != null: # If there's a state,
		state.update( delta ) # Call its update virtual function

func _physics_process(delta): # Every physics frame
	if state != null: # If there's a state,
		state.physics_update( delta ) # Call its physics_update virtual function


# Custom functions
func decide_next_action(): # Decide what to do next
	print( "Deciding..." )
	var weights = sm_owner.get_weights()
	print( weights )
	var decision = pick_weighted( weights )
	
	match decision:
		"wait": # Wait
			print( "I want to wait" )
			transition_to( "Idle" ) # Switch to idle state
		"wander": # Wander
			print( "I want to wander" )
			# Pick a random x coordinate in range
			var x = randf_range( wander_x_min, wander_x_max )
			# Pick a random y coordinate in range
			var y = randf_range( wander_y_min, wander_y_max )
			var msg = { # Let the walking state know...
				"goal": "wander", # the pet's just wandering,
				"target": Vector2(x, y) # and where it's going
			}
			transition_to( "Walking", msg ) # Switch to walking state
		"eat": # Eat
			print( "I want to eat" )
			var nearest_food = null # Find the nearest fruit
			for x in sm_owner.dec_influences: # Look at the decision influences
				if x.is_in_group( "Food" ) and nearest_food == null:
					# If it's food and we haven't found another food yet
					nearest_food = x # It's the nearest food
				elif x.is_in_group( "Food" ): # If it is food, but we already found one
					var food_pos = x.global_position # Compare the position of this food
					var near_pos = nearest_food.global_position # To the nearest food
					if (sm_owner.global_position - food_pos) < (sm_owner.global_position - near_pos):
						# If it's closer, replace the nearest food with this food
						nearest_food = x
			
			if nearest_food != null: # If there is any food in the garden,
				print( "and I can!" )
				var msg = { # Let the walking state know...
					"goal": "eat", # the pet wants to eat
					"target": nearest_food.global_position, # where the food is
					"next_msg": { # and WHAT the food is (for the eating state)
						"food": nearest_food
					}
				}
				transition_to( "Walking", msg )
			else: # If there's no food in the garden,
				print( "but I can't :(" )
				decide_next_action() # Decide a new action
		"sleep": # Sleep
			print( "I want to sleep" ) # But that's not implemented yet
			decide_next_action() # This is the equivalent of pass
		_:
			print( "This shouldn't happen. pick_weighted() returned " + decision )

func transition_to( target_state_path: String, msg: Dictionary = {} ) -> void:
	# Transition to the passed-in state.
	assert( has_node( target_state_path ) ) # Make sure it exists
	if state != null:
		state.exit() # Run old state's exit code
	state = get_node( target_state_path ) # Change states
	state.enter( msg ) # Run new state's enter code
	emit_signal( "transitioned", state.name ) # Emit transitioned signal

func pick_weighted( weights : Dictionary ) -> String:
	# Pick a random option based on the associated probability
	# Shout outs to @SnepGem on Cohost for helping me with this :)
	var no_blanks = weights.duplicate() # Make a duplicate dictionary
	for k in weights: # Find all the options with a 0% probability
		if weights[k] <= 0.000001: # (accounting for float weirdness)
			no_blanks.erase( k ) # and remove them from the duplicate
	
	var choice = randf() # Generate a random float between 0.0 and 1.0
	var target_prob = 0.0
	
	for k in no_blanks:
		target_prob += no_blanks[k]
		if choice < target_prob:
			return k
	
	return "" # This should never happen, but I get an error if it isn't here.
