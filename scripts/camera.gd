extends Camera2D


# Variables
@export var focus : Node2D # The object that the camera will focus on


# Engine functions
func _process(delta): # Every frame
	position = focus.position # Move to focus's position
