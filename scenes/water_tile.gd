extends Area2D
@onready var character_body_2d = %CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_body_entered(body):
	if (body.name == "CharacterBody2D"):
		body.in_water = true
	
	
func _on_body_exited(body):
	if (body.name == "CharacterBody2D"):
		body.in_water = false


