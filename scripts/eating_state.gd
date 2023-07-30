extends State


# Variables
var food = null # The food currently being eaten


# Virtual functions from State
func enter( msg := {} ) -> void: # When pet enters this state
	food = msg.food # Save the node the pet was moving to
	if controlled_object.near.has( food ): # If the food the pet was moving to is near it, 
		# TODO: This doesn't work. Find out why.
		food.get_parent().remove_child( food ) # Remove food from the main scene (seems convoluted)
		controlled_object.remove_near( food ) # Take it out of the pet's near array
		food.position = Vector2.ZERO # Reset it's position to 0
		controlled_object.add_child( food ) # Make it a child of the pet
		bite() # Bite the food
	else: # If the food is not there anymore,
		state_machine.decide_next_action() # Decide a new action

func exit() -> void: # When pet leaves this state
	food = null # Reset the food variable


# Custom functions
func bite(): # When the pet bites the food
	food.shrink() # Make the food get smaller
	await get_tree().create_timer(1.5).timeout # Wait a bit
	# TODO: Wait time should be a variable
	if is_instance_valid( food ): # If the food still exists (hasn't been freed)
		# TODO: Decide whether to bite again, based on hunger
		bite() # Bite again
	else: # If there's no food to eat,
		state_machine.decide_next_action() # Decide a new action
