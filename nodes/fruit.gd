class_name Fruit
extends Area2D


# Variables
@onready var sprite = $Sprite2D # The sprite of the fruit.

var size = 4 # Size category of the fruit. How many bites can be taken out of it.


# Custom functions
func shrink(): # The fruit reduces by one size category, or frees if it's at its smallest
	match size: # There's gotta be a more efficient way to do this
		4:
			sprite.scale = Vector2( 0.4, 0.4 ) # And the scales should probably be variables
		3:
			sprite.scale = Vector2( 0.3, 0.3 )
		2:
			sprite.scale = Vector2( 0.2, 0.2 )
		1: # If it's already the smallest it can be,
			queue_free() # The fruit is destroyed
	
	size -= 1 # Reduce size by 1. If the fruit is freed before this, that's fine.


# Signal functions
func _on_body_entered(body): # If something enters the area,
	if body is Pet: # If that something is a pet,
		body.add_near( self ) # Let the pet know the fruit is nearby

func _on_body_exited(body): # If something leaves the area,
	if body is Pet: # If that something is a pet,
		body.remove_near( self ) # Let the pet know the fruit is no longer nearby
