class_name Fruit
extends Area2D


func _on_body_entered(body):
	if body is Pet:
		pass # Let the pet know it's close to the fruit


func _on_body_exited(body):
	if body is Pet:
		pass # Let the pet know it's no longer close to the fruit
