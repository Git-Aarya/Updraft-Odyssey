extends PathFollow2D

@export var player_path: NodePath
@export var vertical_offset: float = 1600 # Offset for the camera's vertical position
var player: Node2D

func _ready():
	if player_path:
		player = get_node(player_path)

func _process(_delta):
	if player:
		# Calculate the progress based on the player's y position, inverted
		progress = - player.global_position.y + vertical_offset
		
		# Ensure the camera's position follows the path at the calculated progress
		set_progress(progress)
		
		# Manually set the camera's position to follow the PathFollow2D node's position
		$Camera2D.global_position = global_position







