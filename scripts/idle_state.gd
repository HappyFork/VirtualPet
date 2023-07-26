extends State


@export var wait_min = 2.0
@export var wait_max = 10.0
@onready var timer = $WaitTimer


# Called by the state machine when it changes to this state
func enter( _msg := {} ) -> void:
	print( "Is this going?" )
	var w = randf_range( wait_min, wait_max )
	timer.wait_time = w
	timer.start()


# Called when WaitTimer times out
func _on_wait_timer_timeout():
	state_machine.decide_next_action()
