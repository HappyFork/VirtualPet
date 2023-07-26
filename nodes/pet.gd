class_name Pet
extends CharacterBody2D


### --- Variables, Enums, & Signals --- ###

# Onready variables
@onready var path = $NavigationAgent2D # Used to get paths on the navigationregion
#@onready var wait_timer = $WaitTimer # Set when deciding to wait

# Export variables
@export var speed = 200.0 # Walking speed

# Regular variables
var state = states.DECIDING # What the pet is doing
var goal = states.DECIDING # What the pet wants to be doing
var dec_influences = [] # Things in the scene that can influence a pet's decision
var near = [] # Things the pet is near
var needs = { # The current state of the pet's needs
	"hunger": 0,
	"energy": 100
}

# Enums
enum states { NONE, DECIDING, WAITING, WALKING, EATING } # What state the pet is/wants to be in

# Signals
signal surveyed( s ) # Sees what's in the room


### --- Engine functions --- ###

## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta):
#	if path.is_navigation_finished():
#		if state == states.WALKING and goal == states.WALKING:
#			state = states.DECIDING
#			decide_action()
#		elif state == states.WALKING and goal == states.EATING and near.any( is_fruit ) :
#			state = states.EATING
#			# TODO: what happens when a pet eats?
#		return
#	
#	var tar = path.get_next_path_position()
#	var pos = global_position
#	var vel : Vector2 = tar - pos
#	
#	vel = vel.normalized()
#	vel = vel * speed
#	
#	velocity = vel
#	move_and_slide()


### --- Custom functions --- ###
## Called deferred by the ready function. Decide what to do first
#func first_decision():
#	emit_signal( "surveyed", self )
#	await get_tree().physics_frame
#	
#	decide_action()
#
#
## Decide what to do next
#func decide_action():
#	if !state == states.DECIDING:
#		return
#	
#	print( "Deciding..." )
#	var decision = randi_range( 0, 2 ) # Randomly choose between wait, wander, and eat
#	
#	match decision:
#		0: # Wait
#			print( "I want to wait" )
#			var w = randf_range( 10.0, 30.0 )
#			state = states.WAITING
#			wait_timer.wait_time = w
#			wait_timer.start()
#		1: # Wander
#			print( "I want to wander" )
#			var x = randf_range( -1100, 1600 )
#			var y = randf_range( -800, 900 )
#			var target = NavigationServer2D.map_get_closest_point( get_world_2d().navigation_map, Vector2( x, y ) )
#			path.set_target_position( target )
#			state = states.WALKING
#		2: # Eat
#			print( "I want to eat..." )
#			var nearest_fruit = null
#			for x in dec_influences:
#				if x.is_in_group( "Food" ) and nearest_fruit == null:
#					nearest_fruit = x.global_position
#				elif x.is_in_group( "Food" ):
#					var food_pos = x.global_position
#					if (global_position - food_pos) < (global_position - nearest_fruit):
#						nearest_fruit = food_pos
#			
#			if nearest_fruit != null:
#				print( "and I can!" )
#				path.set_target_position( nearest_fruit )
#				state = states.WALKING
#			else:
#				print( "but I can't :(" )
#				pass # :(
#	
#	decide_action()

# Adds the passed node to the near array
func add_near( node ):
	near.append( node )

# Removes all instances of the passed node from the near array
func remove_near( node ):
	if near.count( node ) > 0:
		for x in range( near.count( node ) ):
			near.erase( node )

# Emit surveyed signal and get nodes in the scene
func survey():
	emit_signal( "surveyed", self )

# Returns true if the passed node is a fruit
func is_fruit( node ):
	if node is Fruit:
		return true
	else:
		return false


### --- Signal functions --- ###

# Called when the wait timer finishes
#func _on_wait_timer_timeout():
#	state = states.DECIDING
#	decide_action()
