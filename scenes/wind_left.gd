extends Area2D


# Adjust the wind force as needed
@export var wind_force: float = -4000.0
@onready var animated_sprite_2d = $AnimatedSprite2D


func _ready():
	# Ensure the sprite is flipped horizontally
	animated_sprite_2d.flip_h = true

func _on_body_entered(body):
	if body is CharacterBody2D:
		body.wind_effect = wind_force


func _on_body_exited(body):
	if body is CharacterBody2D:
		body.wind_effect = 0.0
