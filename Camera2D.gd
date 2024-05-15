extends Camera2D
@onready var player = $"."

# Reference to the player node

# Fixed horizontal position of the camera
var fixed_x = 540  # Adjust this to set the desired horizontal position

func _process(delta):
	var new_y = player.global_position.y
	global_position = Vector2(fixed_x, new_y)

