extends State


var food = null


func bite():
	food.shrink()
	await get_tree().create_timer(1.5).timeout
	if is_instance_valid( food ):
		# TODO: Decide whether to bite again, based on hunger
		bite()
	else:
		state_machine.decide_next_action()

# Called by the state machine when it changes to this state
func enter( msg := {} ) -> void:
	if controlled_object.near.has( food ):
		# TODO: This doesn't work. Find out why.
		food = msg.food
		food.get_parent().remove_child( food ) # Lol, seems convoluted
		controlled_object.remove_near( food )
		food.position = Vector2.ZERO
		controlled_object.add_child( food )
		bite()
	else:
		state_machine.decide_next_action()

# Called by the state machine when it chages from this state to another one
func exit() -> void:
	food = null
