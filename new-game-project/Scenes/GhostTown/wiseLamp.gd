extends Area2D

var player_inside = false
var player
var dialogue_played = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not dialogue_played:
		player_inside = true
		player = body

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = false
		player = null

func _process(delta: float) -> void:
	if player_inside and Input.is_action_just_pressed("interact") and not dialogue_played:
		start_interaction()

func start_interaction() -> void:
	if DialogueManager == null:
		printerr("DialogueManager is null! Make sure it's properly instantiated.")
		return

	dialogue_played = true
	if player:
		player.set_physics_process(false)
		var animation_player = player.get_node("AnimationPlayer")
		if animation_player:
			var current_animation = animation_player.assigned_animation
			if "idle" in current_animation:
				animation_player.play(current_animation)
			else:
				animation_player.play("idle_r")

	var dialogue_resource = load("res://scripts/wiseLamp.dialogue")
	if dialogue_resource == null:
		printerr("Failed to load dialogue resource!")
		return

	DialogueManager.show_dialogue_balloon(dialogue_resource, "start")
	DialogueManager.connect("dialogue_ended", Callable(self, "_on_dialogue_ended"), CONNECT_DEFERRED)

func _on_dialogue_ended() -> void:
	if player and is_instance_valid(player):
		player.set_physics_process(true)
