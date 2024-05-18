extends Sprite2D

@export var min_y_position: float = -10000
@export var max_y_position: float = -22700

func _process(delta):
	if global_position.y < min_y_position:
		global_position.y = min_y_position
	elif global_position.y > max_y_position:
		global_position.y = max_y_position
