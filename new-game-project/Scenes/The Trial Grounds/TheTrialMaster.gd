extends Area2D

var player_inside: bool = false
var dialogue_played: bool = false
var player: Node = null
var played_second_frame := false

@onready var trial_master_sprite: AnimatedSprite2D = $Throne
@onready var black_flash: ColorRect = $BlackFlash
@onready var interact_prompt: Node = $InteractE  # This is your "E" icon

func _ready():
	interact_prompt.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = true
		player = body
		interact_prompt.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = false
		player = null
		interact_prompt.visible = false

func _process(delta: float) -> void:
	if player_inside and Input.is_action_just_pressed("interact") and not dialogue_played:
		dialogue_played = true
		interact_prompt.visible = false  # Hide E when dialogue starts

		if player:
			player.set_physics_process(false)
			var animation_player = player.get_node_or_null("AnimationPlayer")
			if animation_player:
				animation_player.play("idle_r")

		GLobal.connect("StandUp", Callable(self, "_on_stand_up"), CONNECT_DEFERRED)
		DialogueManager.show_dialogue_balloon(load("res://scripts/trialmaster.dialogue"), "start")
		DialogueManager.connect("dialogue_ended", Callable(self, "_on_dialogue_ended"), CONNECT_DEFERRED)

func _on_stand_up():
	if trial_master_sprite:
		trial_master_sprite.frame = 1

	await play_black_flash()

func _on_dialogue_ended():
	DialogueManager.disconnect("dialogue_ended", Callable(self, "_on_dialogue_ended"))
	DialogueManager.disconnect("StandUp", Callable(self, "_on_stand_up"))

	if trial_master_sprite and not played_second_frame:
		trial_master_sprite.frame = 2
		played_second_frame = true

		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://Scenes/creds/creds.tscn")

func play_black_flash() -> Signal:
	black_flash.visible = true
	black_flash.modulate.a = 0.0

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(black_flash, "modulate:a", 1.0, 0.005)
	tween.tween_interval(0.05)
	tween.tween_property(black_flash, "modulate:a", 0.0, 0.05)

	await tween.finished
	black_flash.visible = false
	return tween.finished
