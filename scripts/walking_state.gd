extends State


@export var path : NavigationAgent2D # I'm going to have to hook this up programmatically at some point
var goal = ""
var next_msg = {}


# Virtual function corresponding to _physics_process()
func physics_update( _delta: float ) -> void:
	if path.is_navigation_finished():
		match goal:
			"eat":
				state_machine.transition_to( "Eating", next_msg )
			_: #"wander", anything else, and nothing
				state_machine.decide_next_action()
		return
	
	var tar = path.get_next_path_position()
	var pos = controlled_object.global_position
	var vel : Vector2 = tar - pos
	
	vel = vel.normalized()
	vel = vel * controlled_object.speed
	
	controlled_object.velocity = vel
	controlled_object.move_and_slide()

# Called by the state machine when it changes to this state
func enter( msg := {} ) -> void:
	var target = msg.target
	var navt = NavigationServer2D.map_get_closest_point( controlled_object.get_world_2d().navigation_map, target )
	goal = msg.goal
	if msg.has( "next_msg" ):
		next_msg = msg.next_msg
	path.set_target_position( navt )

# Called by the state machine when it chages from this state to another one
func exit() -> void:
	goal = ""
	next_msg = {}
