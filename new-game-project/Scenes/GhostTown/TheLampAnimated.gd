extends Area2D

@onready var animated_sprite = $"the animated"  # Reference to AnimatedSprite2D
@onready var player = null  # Reference to the player (set when they enter)
var player_inside = false
var interaction_done = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = true
		player = body  # Store player reference

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = false
		player = null

func _process(delta: float) -> void:
	if player_inside and Input.is_action_just_pressed("interact") and not interaction_done:
		interaction_done = true
		start_interaction()

func start_interaction() -> void:
	# Disable player movement
	if player and is_instance_valid(player):
		player.set_physics_process(false)

	animated_sprite.play("lamp_animation")  # Start animation
	await get_tree().create_timer(0.6).timeout  

	# Pause at frame 3
	animated_sprite.stop()
	animated_sprite.frame = 3

	# Start dialogue
	DialogueManager.show_dialogue_balloon(load("res://scripts/LampConvo.dialogue"), "start")
	DialogueManager.connect("dialogue_ended", Callable(self, "_on_dialogue_ended"), CONNECT_DEFERRED)

func _on_dialogue_ended() -> void:
	# Switch to frame 4
	animated_sprite.frame = 4
	await get_tree().create_timer(0.2).timeout  # Short delay to make frame 4 visible

	# Then switch to frame 1
	animated_sprite.frame = 0

	# Re-enable player movement
	if player and is_instance_valid(player):
		player.set_physics_process(true)

	interaction_done = false  # Reset interaction
	DialogueManager.disconnect("dialogue_ended", Callable(self, "_on_dialogue_ended"))  # Cleanup signal connection
