extends State


# Variables
@export var path : NavigationAgent2D # The pet's navigation agent

var goal = "" # What the pet wants to do after it moves
var next_msg = {} # Msg that will be passed to the next state


# Virtual functions from State
func physics_update( _delta: float ) -> void: # Every physics frame
	if path.is_navigation_finished(): # If the pet is where it's going,
		match goal: # Do what it wants to do next
			"eat": 
				state_machine.transition_to( "Eating", next_msg )
			_: #"wander", anything else, and nothing
				state_machine.decide_next_action()
		return # And then don't go on
	
	# I'll be real I don't fully understand this next part. I took it from a
	# navigation tutorial
	var tar = path.get_next_path_position()
	var pos = controlled_object.global_position
	var vel : Vector2 = tar - pos
	
	vel = vel.normalized()
	vel = vel * controlled_object.speed
	
	controlled_object.velocity = vel
	controlled_object.move_and_slide()

func enter( msg := {} ) -> void: # When pet enters this state
	var target = msg.target # Get the target from the message
	# Get the closest spot on the navigable map to the target
	var navt = NavigationServer2D.map_get_closest_point( controlled_object.get_world_2d().navigation_map, target )
	goal = msg.goal # Get the goal from the message
	if msg.has( "next_msg" ): # If the message has a next message,
		next_msg = msg.next_msg # get it
	path.set_target_position( navt ) # Set the nav agent's target to the navigable location

func exit() -> void: # When pet leaves this state
	goal = "" # Reset goal
	next_msg = {} # Reset next message
