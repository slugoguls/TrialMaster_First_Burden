extends Node2D

@onready var base_sprite := $Base
@onready var selected_sprite := $StartSelected
@onready var preq_sprite := $Preq
@onready var resolve_sprite := $Resolve
@onready var fade_rect := $Fade/ColorRect

var current_stage := 0
var fading := false

func _ready():
	# Show only the base menu initially
	base_sprite.visible = true
	selected_sprite.visible = false
	preq_sprite.visible = false
	resolve_sprite.visible = false

	# Make sure fade starts fully transparent
	fade_rect.color = Color(0, 0, 0, 0)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and not fading:
		match current_stage:
			0:
				# First press: highlight "Start"
				base_sprite.visible = false
				selected_sprite.visible = true
				current_stage += 1

			1:
				# Second press: fade to Preq
				await fade_to_black()
				selected_sprite.visible = false
				preq_sprite.visible = true
				await fade_from_black()
				current_stage += 1

			2:
				# Third press: fade to Resolve
				await fade_to_black()
				preq_sprite.visible = false
				resolve_sprite.visible = true
				await fade_from_black()
				current_stage += 1

			3:
				# Final press: transition to game
				await fade_to_black()
				start_game()

func start_game():
	get_tree().change_scene_to_file("res://Scenes/TheStart/start.tscn")

# === FADE HELPERS ===

func fade_to_black():
	fading = true
	var duration = 1.0
	var t = 0.0
	while t < duration:
		t += get_process_delta_time()
		var alpha = clamp(t / duration, 0, 1)
		fade_rect.color = Color(0, 0, 0, alpha)
		await get_tree().process_frame
	fading = false

func fade_from_black():
	fading = true
	var duration = 1.0
	var t = 0.0
	while t < duration:
		t += get_process_delta_time()
		var alpha = 1.0 - clamp(t / duration, 0, 1)
		fade_rect.color = Color(0, 0, 0, alpha)
		await get_tree().process_frame
	fading = false
