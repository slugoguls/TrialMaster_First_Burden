extends CharacterBody2D

const SPEED = 100
const JUMP_VELOCITY = -400.0
const GRAVITY = 980.0 # Standard gravity value

@onready var animation_player = $AnimationPlayer
@onready var map_sprite = $Map
var is_attacking = false
var is_facing_left = false
var is_map_open = false
 # Gravity is disabled by default

func _ready():
	PlayerManager.player_instance = self
	add_to_group("player")
	map_sprite.visible = false

func _physics_process(delta: float) -> void:
	# Apply gravity if enabled
	if GLobal.use_gravity and not is_on_floor():
		velocity.y += GRAVITY * delta

	# Prevent map from opening during an attack
	if Input.is_action_just_pressed("ui_map") and not is_attacking and GLobal.map:
		is_map_open = !is_map_open
		map_sprite.visible = is_map_open

		# Force idle animation and stop movement when the map is open
		velocity = Vector2.ZERO
		if is_facing_left:
			animation_player.play("idle_l")
		else:
			animation_player.play("idle_r")
		return

	# Prevent movement and attacking when the map is open
	if is_map_open or is_attacking:
		velocity.x = 0
		return

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle attack
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		if is_facing_left:
			animation_player.play("light_attack_l")
		else:
			animation_player.play("light_attack_r")
		return

	# Get the input direction and handle movement
	var direction := Input.get_axis("left", "right")

	# Determine facing direction based on movement
	if direction > 0:
		is_facing_left = false
	elif direction < 0:
		is_facing_left = true

	# Move player and play appropriate animations
	if direction != 0:
		velocity.x = direction * SPEED
		if velocity.x > 0:
			animation_player.play("run_r")
		else:
			animation_player.play("run_l")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_facing_left:
			animation_player.play("idle_l")
		else:
			animation_player.play("idle_r")

	move_and_slide()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "light_attack_r" or anim_name == "light_attack_l":
		is_attacking = false
		if is_facing_left:
			animation_player.play("idle_l")
		else:
			animation_player.play("idle_r")
