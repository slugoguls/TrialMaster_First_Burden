extends Area2D

@onready var interact_sprite = $InteractE
@onready var interact_sprite_light = $InteractE/PointLight2D
var player_inside = false
var done = false
var player
var dialogue_played = false

func _ready() -> void:
	interact_sprite.modulate = Color(1, 1, 1, 0)
	interact_sprite_light.energy = 0
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = true
		player = body
		fade_in_interactE()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = false
		player = null
		fade_out_interactE()

func _process(delta: float) -> void:
	if player_inside and Input.is_action_just_pressed("interact") and not dialogue_played:
		hide_interactE()
		dialogue_played = true
		
		if player:
			player.set_physics_process(false)
			var animation_player = player.get_node("AnimationPlayer")
			if animation_player:
				animation_player.play("idle_r")
			DialogueManager.show_dialogue_balloon(load("res://scripts/Brother_first.dialogue"), "start")
			DialogueManager.connect("dialogue_ended", Callable(self, "_on_dialogue_ended"), CONNECT_DEFERRED)
			print("Connected dialogue_ended signal.")


# Re-enable movement when dialogue ends
func _on_dialogue_ended():
	print("Dialogue ended signal received!")
	GLobal.map = true
	if player and is_instance_valid(player):
		player.set_physics_process(true)

# Functions to fade in/out using interpolation
func fade_in_interactE():
	if not done:
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(interact_sprite, "modulate", Color(1, 1, 1, 1), 0.2)
		tween.tween_property(interact_sprite_light, "energy", 1.0, 0.2)

func fade_out_interactE():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(interact_sprite, "modulate", Color(1, 1, 1, 0), 0.5)
	tween.tween_property(interact_sprite_light, "energy", 0.0, 0.2)

# Instantly hide interact prompt and light on interaction
func hide_interactE():
	done = true
	interact_sprite_light.energy = 0
	interact_sprite.modulate = Color(1, 1, 1, 0)
