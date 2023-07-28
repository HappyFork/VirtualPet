class_name Pet
extends CharacterBody2D


# Variables
@export var speed = 200.0 # Walking speed

@onready var path = $NavigationAgent2D # Used to get paths on the navigation region
@onready var state_machine = $StateMachine # The pet's state machine

var dec_influences : Array[Node] # Things in the garden that can influence a pet's decision
var near : Array[Node] # Things the pet is near
var needs = { # The current state of the pet's needs
	"hunger": 0,
	"energy": 100
}

signal surveyed( s ) # Sees what's in the garden


# Custom functions
func add_near( node ): # Adds the passed node to the near array
	near.append( node )

func remove_near( node ): # Removes all instances of the passed node from the near array
	if near.count( node ) > 0: # If the node is in the array
		for x in range( near.count( node ) ): # For every instance of the node in the array
			near.erase( node ) # Remove it

func survey(): # Emit surveyed signal and get decision impacts in the garden
	emit_signal( "surveyed", self )
