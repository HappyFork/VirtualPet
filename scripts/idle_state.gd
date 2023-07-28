extends State


# Variables
@export var wait_min = 2.0 # Minimum wait time
@export var wait_max = 10.0 # Maximum wait time

@onready var timer = $WaitTimer # Wait timer


# Virtual functions from State
func enter( _msg := {} ) -> void: # When pet enters this state
	#print( "Entering idle state." )
	var w = randf_range( wait_min, wait_max ) # Pick a random time between the min and max
	timer.wait_time = w # Set the timer's wait time for that length
	timer.start() # Start the timer


# Signal functions
func _on_wait_timer_timeout(): # Called when WaitTimer times out
	state_machine.decide_next_action() # Decide a new action
