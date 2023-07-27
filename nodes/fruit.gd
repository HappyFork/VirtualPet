class_name Fruit
extends Area2D


var size = 4
@onready var sprite = $Sprite2D


func shrink():
	match size:
		4:
			sprite.scale = Vector2( 0.4, 0.4 )
		3:
			sprite.scale = Vector2( 0.3, 0.3 )
		2:
			sprite.scale = Vector2( 0.2, 0.2 )
		1:
			queue_free()
	
	size -= 1


func _on_body_entered(body):
	if body is Pet:
		body.add_near( self )


func _on_body_exited(body):
	if body is Pet:
		body.remove_near( self )
