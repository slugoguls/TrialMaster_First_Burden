extends Area2D

var player_inside: bool = false
var dialogue_played: bool = false
var player: Node = null

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = true
		player = body

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = false
		player = null

func _process(delta: float) -> void:
	if player_inside and Input.is_action_just_pressed("interact") and not dialogue_played:
		dialogue_played = true

		if player:
			player.set_physics_process(false)
			var animation_player = player.get_node_or_null("AnimationPlayer")
			if animation_player:
				animation_player.play("idle_r")

		DialogueManager.show_dialogue_balloon(load("res://scripts/trialmaster.dialogue"), "start")
		DialogueManager.connect("dialogue_ended", Callable(self, "_on_dialogue_ended"), CONNECT_DEFERRED)
		print("Connected dialogue_ended signal.")

func _on_dialogue_ended():
	if player and is_instance_valid(player):
		player.set_physics_process(true)

	DialogueManager.disconnect("dialogue_ended", Callable(self, "_on_dialogue_ended"))
