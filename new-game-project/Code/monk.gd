extends CharacterBody2D

const SPEED = 100
const JUMP_VELOCITY = -350.0
const GRAVITY = 980.0

@onready var animation_player = $AnimationPlayer
@onready var map_sprite = $CanvasLayer/Map
var is_attacking = false
var is_facing_left = false
var is_map_open = false

func _ready():
	PlayerManager.player_instance = self
	add_to_group("player")
	map_sprite.visible = false

func _physics_process(delta: float) -> void:
	# Check if gravity is enabled
	if GLobal.use_gravity:
		# Apply gravity if not on the floor
		if not is_on_floor():
			velocity.y += GRAVITY * delta
	else:
		# Prevent gravity and ensure player floats in first scene
		velocity.y = 0

	# Toggle map visibility
	if Input.is_action_just_pressed("ui_map") and not is_attacking and GLobal.map:
		is_map_open = !is_map_open
		map_sprite.visible = is_map_open
		velocity = Vector2.ZERO
		animation_player.play("idle_l" if is_facing_left else "idle_r")
		return

	if is_map_open or is_attacking:
		velocity.x = 0
		return

	# Handle Jump if Gravity is enabled
	if GLobal.use_gravity and Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation_player.play("jump_up_l" if is_facing_left else "jump_up_r")
		return

	# Jump Animation Logic
	if GLobal.use_gravity and not is_on_floor():
		if velocity.y < 0:
			animation_player.play("jump_up_l" if is_facing_left else "jump_up_r")
		elif velocity.y > 0:
			animation_player.play("jump_down_l" if is_facing_left else "jump_down_r")
		elif abs(velocity.y) < 10:
			animation_player.play("jump_peak_l" if is_facing_left else "jump_peak_r")
	else:
		# Return to idle or run on landing
		if velocity.x == 0:
			animation_player.play("idle_l" if is_facing_left else "idle_r")
		else:
			animation_player.play("run_l" if is_facing_left else "run_r")

	# Attack Handling
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		animation_player.play("light_attack_l" if is_facing_left else "light_attack_r")
		return

	# Movement Input
	var direction := Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = direction * SPEED
		is_facing_left = direction < 0
		if is_on_floor() or not GLobal.use_gravity:
			animation_player.play("run_l" if is_facing_left else "run_r")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name in ["light_attack_r", "light_attack_l"]:
		is_attacking = false
		animation_player.play("idle_l" if is_facing_left else "idle_r")
