extends Area2D

@onready var interact_sprite = $InteractE
@onready var interact_sprite_light = $InteractE/PointLight2D
var player_inside = false
var player
var dialogue_played = false

func _ready() -> void:
	interact_sprite.modulate = Color(1, 1, 1, 0)
	interact_sprite_light.energy = 0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not dialogue_played:
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
		start_interaction()

func start_interaction() -> void:
	if DialogueManager == null:
		printerr("DialogueManager is null! Make sure it's properly instantiated.")
		return

	dialogue_played = true
	hide_interactE()
	if player:
		player.set_physics_process(false)
		var animation_player = player.get_node("AnimationPlayer")
		if animation_player:
			animation_player.play("idle_r")

	var dialogue_resource = load("res://scripts/nocBhai1.dialogue")
	if dialogue_resource == null:
		printerr("Failed to load dialogue resource!")
		return

	DialogueManager.show_dialogue_balloon(dialogue_resource, "start")
	DialogueManager.connect("dialogue_ended", Callable(self, "_on_dialogue_ended"), CONNECT_DEFERRED)

func _on_dialogue_ended() -> void:
	if player and is_instance_valid(player):
		player.set_physics_process(true)
	fade_out_interactE()

# Functions to fade in/out using interpolation
func fade_in_interactE() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(interact_sprite, "modulate", Color(1, 1, 1, 1), 0.2)
	tween.tween_property(interact_sprite_light, "energy", 1.0, 0.2)

func fade_out_interactE() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(interact_sprite, "modulate", Color(1, 1, 1, 0), 0.5)
	tween.tween_property(interact_sprite_light, "energy", 0.0, 0.2)

func hide_interactE() -> void:
	interact_sprite_light.energy = 0
	interact_sprite.modulate = Color(1, 1, 1, 0)
