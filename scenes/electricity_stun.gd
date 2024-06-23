extends Area2D
@onready var character_body_2d = %CharacterBody2D
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

func _on_body_entered(body):
	if (body.name == "CharacterBody2D"):
		audio_stream_player_2d.play()
		character_body_2d.stun()
		
	
