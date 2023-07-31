extends CanvasLayer


# Variables
@export var focus : Node2D

@onready var state_label = $Panel/VBoxContainer/Grid/State
@onready var hunger_label = $Panel/VBoxContainer/Grid/Hunger
@onready var energy_label = $Panel/VBoxContainer/Grid/Energy


# Engine functions
func _process(delta): # Every frame
	state_label.text = focus.state_machine.state.name
	hunger_label.text = str( focus.needs.hunger )
	energy_label.text = str( focus.needs.energy )
