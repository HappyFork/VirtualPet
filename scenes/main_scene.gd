extends Node2D


# Variables
@onready var pet = $Pet # For debug
@onready var db_label = $UI/Panel/Label # For debug

var dec_influences : Array[Node] # Things that can influence a pet's decision


# Engine functions
func _ready(): # When the scene starts
	var kids = get_children() # Get all the children nodes
	for k in kids: # Check each child
		if k.is_in_group( "DecImpact" ): # for each in the DecImpact group,
			dec_influences.append( k ) # add to dec_influences array
	for k in kids: # Check each child
		if k is Pet: # for each pet,
			k.dec_influences = dec_influences # send it the dec_influences array

func _process(delta): # Every frame
	db_label.text = pet.state_machine.state.name # Show the pet's state in the panel
	# TODO: This crashes right now bc the state machine doesn't have a state at first


# Signal functions
func _on_child_entered_tree(node): # Called when a child node is added
	#print( "Child entered" )
	if node.is_in_group( "DecImpact" ): # If it's in the DecImpact group,
		#print( "Adding " + node.name )
		dec_influences.append( node ) # Add it to the dec_influences array

func _on_child_exiting_tree(node): # Called when a child node is removed
	print( "Child exited" )
	if node.is_in_group( "DecImpact" ) and dec_influences.count( node ) > 0:
		# If it's in the DecImpact group and in the dec_influences array,
		for i in range( dec_influences.count( node ) ): # Remove all instances of it
			dec_influences.erase( node ) # from the dec_influences array

func _on_pet_surveyed( looking : Pet ): # Called when a pet surveys the garden
	looking.dec_influences = dec_influences # Send it the dec_influences array

func _on_timer_timeout():
	for k in get_children():
		if k is Pet:
			k.pass_time()
