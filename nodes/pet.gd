extends CharacterBody2D


# Variables
@onready var path = $NavigationAgent2D
@export var speed = 200.0


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	call_deferred( "decide_target" )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if path.is_navigation_finished():
		return
	
	var tar = path.get_next_path_position()
	var pos = global_position
	var vel : Vector2 = tar - pos
	
	vel = vel.normalized()
	vel = vel * speed
	
	velocity = vel
	move_and_slide()


# Decide where to go next
func decide_target():
	await get_tree().physics_frame
	
	var x = randf_range( -1100, 1600 )
	var y = randf_range( -800, 900 )
	var target = NavigationServer2D.map_get_closest_point( get_world_2d().navigation_map, Vector2( x, y ) )
	path.set_target_position( target )
