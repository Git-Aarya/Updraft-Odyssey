extends CharacterBody2D

const SPEED = 450.0
const JUMP_VELOCITY = -950
@onready var sprite_2d = $Sprite2D

var facing_right = true  # Keeps track of which direction the character is facing
var disengaged_from_wall = true  # Flag to check if character has moved away from the wall

# Get the gravity from the project settings.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Handle animations
	if not is_on_floor():
		#sprite_2d.animation = "jumping"
		velocity.y += gravity * delta  # Properly use delta for gravity application
	#else:
		#sprite_2d.animation = "default"
	
	# Handle jumping and horizontal movement
	if Input.is_action_just_pressed("tap"):
		velocity.y = JUMP_VELOCITY
		if facing_right:
			velocity.x = SPEED
		else:
			velocity.x = -SPEED

	move_and_slide()  # Adjusted to have no arguments per your project's setup

	# Check for wall collisions to change direction
	var has_collided = false
	if get_slide_collision_count() > 0:
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			if collision.get_normal().x != 0:
				has_collided = true
				if disengaged_from_wall:
					facing_right = not facing_right
					sprite_2d.flip_h = not sprite_2d.flip_h
					disengaged_from_wall = false  # Set flag to false after changing direction
				break

	# Reset disengagement flag if no wall collision
	if not has_collided:
		disengaged_from_wall = true




