extends CharacterBody2D

const SPEED = 450.0
const JUMP_VELOCITY = -950
@onready var sprite_2d = $Sprite2D

var facing_right = true  # Keeps track of which direction the character is facing
var disengaged_from_wall = true  # Flag to check if character has moved away from the wall
var is_dead = false  # Flag to indicate if the character is dead
var game_started = false  # Flag to indicate if the game has started
var wind_effect: float = 0.0

# Gravity
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if is_dead or not game_started:
		# If the character is dead or the game hasn't started, don't process movement or collisions
		return

	# Handle animations
	if velocity.y < 0:
		sprite_2d.animation = "flying"
	else:
		sprite_2d.animation = "idle"

	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta  # Properly use delta for gravity application
		# Apply wind effect
		velocity.x += wind_effect * delta
	
	# Handle jumping and horizontal movement
	if Input.is_action_just_pressed("right"):
		move_right()
	elif Input.is_action_just_pressed("left"):
		move_left()

	# Move the character and check for collisions
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		# Check if the collider is in the "death" group
		var collider = collision_info.get_collider()
		if collider and collider.is_in_group("death"):
			die()

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

func move_right():
	velocity.y = JUMP_VELOCITY
	velocity.x = SPEED
	facing_right = true
	sprite_2d.flip_h = false  # Ensure the sprite faces right

func move_left():
	velocity.y = JUMP_VELOCITY
	velocity.x = -SPEED
	facing_right = false
	sprite_2d.flip_h = true  # Ensure the sprite faces left

func die():
	if is_dead:
		return  # Prevent the die function from being called multiple times

	# Handle death animation
	is_dead = true
	sprite_2d.animation = "dying"

func _input(event):
	if is_dead:
		# If the character is dead, wait for any input to reset the level
		if event is InputEvent:
			reset_game()
	elif not game_started:
		# If the game hasn't started, start the game on any input
		if event is InputEvent:
			game_started = true
	else:
		# Handle regular input
		if event is InputEventScreenTouch and event.pressed:
			if event.position.x < get_viewport_rect().size.x / 2:
				move_left()
			else:
				move_right()

func reset_game():
	# Handle actual death logic, such as resetting the level or showing a game over screen
	get_tree().reload_current_scene()
















func _on_flame_blue_body_entered(body):
	pass # Replace with function body.
