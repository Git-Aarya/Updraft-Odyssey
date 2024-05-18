extends Area2D

# Adjust the wind force as needed
@export var wind_force: float = 4000.0

func _on_body_entered(body):
	if body is CharacterBody2D:
		body.wind_effect = wind_force


func _on_body_exited(body):
	if body is CharacterBody2D:
		body.wind_effect = 0.0
