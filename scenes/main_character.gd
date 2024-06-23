extends CharacterBody2D

const SPEED = 450.0
const JUMP_VELOCITY = -950
@onready var sprite_2d = $Sprite2D
@onready var death_screen = %DeathScreen
@onready var death_sfx_player = $DeathSFXPlayer


var facing_right = true  # Keeps track of which direction the character is facing
var disengaged_from_wall = true  # Flag to check if character has moved away from the wall
var is_dead = false  # Flag to indicate if the character is dead
var game_started = false  # Flag to indicate if the game has started
var wind_effect: float = 0.0
var wind_updraft: float = 0.0
var is_stunned = false  # Flag to indicate if the character is stunned
var in_safe_spot = false  # Flag to indicate if the character is in a safe spot
var in_water = false  # Flag to indicate if the character is in water
var speed: float = SPEED
var water_speed: float = SPEED * 0.5
var water_cooldown = false  # Cooldown flag for exiting water

# Starting position
var start_position: Vector2 = Vector2(555, 581) #Original 555,581

# Gravity
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	# Set the initial position
	global_position = start_position
	reset_player()
	death_screen.visible = false  # Hide the death screen initially

func _physics_process(delta):
		
	if is_dead or is_stunned:
		# If the character is dead or stunned, don't process movement or collisions
		return

	if in_safe_spot:
		# Implement rest mechanics, e.g., regeneration, disabling movement, etc.
		sprite_2d.animation = "swimming"
		return
		

	if not game_started:
		# Prevent the character from falling at the start
		velocity.y = 0
		sprite_2d.animation = "flying"
	else:
		# Handle animations
		if velocity.y < 0:
			sprite_2d.animation = "flying"
		elif velocity.y == 0:
			sprite_2d.animation = "swimming"
		else:
			sprite_2d.animation = "idle"

		if in_water:
			# Only allow movement based on player input, no gravity effect
			velocity.y = 0
			if Input.is_action_just_pressed("right"):
				move_right()
			elif Input.is_action_just_pressed("left"):
				move_left()
			else:
				velocity.x = 0  # Stop horizontal movement if no input
		else:
			# Apply gravity
			if not is_on_floor():
				velocity.y += gravity * delta  # Properly use delta for gravity application

			# Apply wind effect
			velocity.x += wind_effect * delta
			
			# Apply wind updraft
			velocity.y += wind_updraft * delta
			
	if Input.is_action_just_pressed("right"):
		game_started = true
		move_right()
	elif Input.is_action_just_pressed("left"):
		game_started = true
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
	if in_water:
		exit_water()
		velocity.x = water_speed
		velocity.y = JUMP_VELOCITY
	else:
		velocity.y = JUMP_VELOCITY
		velocity.x = speed
	facing_right = true
	sprite_2d.flip_h = false  # Ensure the sprite faces right

func move_left():
	if in_water:
		exit_water()
		velocity.x = -water_speed
		velocity.y = JUMP_VELOCITY
	else:
		velocity.y = JUMP_VELOCITY
		velocity.x = -speed
	facing_right = false
	sprite_2d.flip_h = true  # Ensure the sprite faces left

func die():
	if is_dead:
		return  # Prevent the die function from being called multiple times

	# Handle death animation
	is_dead = true
	sprite_2d.animation = "dying"
	game_started = false
	death_sfx_player.play()
	show_death_screen()

func stun():
	is_stunned = true
	sprite_2d.animation = "stunned"
	await get_tree().create_timer(1.0).timeout
	is_stunned = false

func _input(event):
	# Handle regular input
	if event is InputEventScreenTouch and event.pressed:
		if event.position.x < get_viewport_rect().size.x / 2:
			game_started = true
			move_left()
			
		else:
			game_started = true
			move_right()

func reset_game():
	# Handle actual death logic, such as resetting the player position and relevant variables instead of reloading the entire scene
	is_dead = false
	game_started = false
	reset_player()

# Reset the player to the starting position and set the appropriate animation
func reset_player():
	global_position = start_position
	velocity = Vector2.ZERO
	sprite_2d.animation = "idle"
	facing_right = true
	sprite_2d.flip_h = false

# New function to handle exiting water with a cooldown
func exit_water():
	water_cooldown = true
	in_water = false
	await get_tree().create_timer(0.5).timeout  # 1.5 second cooldown
	water_cooldown = false

# Function to show the death screen
func show_death_screen():
	death_screen.visible = true










