extends Sprite2D
@export var max_y_position: float = -10000

func _process(delta):
	if global_position.y > max_y_position:
		global_position.y = max_y_position
