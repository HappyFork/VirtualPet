extends Node2D


# Variables
@onready var pet = $Pet # For debug
@onready var db_label = $UI/Panel/Label # For debug
var dec_influences : Array[Node]


# Engine functions
func _ready():
	var kids = get_children()
	for k in kids:
		if k.is_in_group( "DecImpact" ):
			dec_influences.append( k )
	for k in kids:
		if k is Pet:
			k.dec_influences = dec_influences

func _process(delta):
	db_label.text = pet.state_machine.state.name


# Signal functions
func _on_child_entered_tree(node):
	#print( "Child entered" )
	if node.is_in_group( "DecImpact" ):
		#print( "Adding " + node.name )
		dec_influences.append( node )


func _on_child_exiting_tree(node):
	#print( "Child exited" )
	if node.is_in_group( "DecImpact" ) and dec_influences.count( node ) > 0:
		for i in range( dec_influences.count( node ) ):
			dec_influences.erase( node )


func _on_pet_surveyed( looking : Pet ):
	looking.dec_influences = dec_influences
