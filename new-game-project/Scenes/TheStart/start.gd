extends Node2D

@onready var slides := [
	$TheStart,
	$TheStart2,
	$TheStart3
]

@onready var dialogue_paths := [
	"res://scripts/start1.dialogue",
	"res://scripts/start2.dialogue",
	"res://scripts/start3.dialogue"
]

@onready var fade_time := 1.5
var current_slide := 0

func _ready():
	for slide in slides:
		slide.visible = false
		slide.modulate.a = 0.0

	show_current_slide()

func show_current_slide():
	var slide: Sprite2D = slides[current_slide]
	var dialogue_path: String = dialogue_paths[current_slide]

	slide.visible = true

	# Only fade in if it's the first slide
	if current_slide == 0:
		await fade_in(slide)
	else:
		slide.modulate.a = 1.0  # Instantly show without fade-in

	DialogueManager.show_dialogue_balloon(load(dialogue_path), "start")
	DialogueManager.connect("dialogue_ended", Callable(self, "_on_dialogue_ended"), CONNECT_DEFERRED)

func _on_dialogue_ended():
	DialogueManager.disconnect("dialogue_ended", Callable(self, "_on_dialogue_ended"))

	if current_slide + 1 < slides.size():
		var current = slides[current_slide]
		current_slide += 1
		var next = slides[current_slide]
		next.visible = true
		next.modulate.a = 0.0

		var tween = create_tween()
		tween.parallel().tween_property(current, "modulate:a", 0.0, fade_time)
		tween.parallel().tween_property(next, "modulate:a", 1.0, fade_time)
		await tween.finished

		show_current_slide()
	else:
		await fade_out(slides[current_slide])
		get_tree().change_scene_to_file("res://Scenes/Snow/keeper's_hut.tscn")

func fade_in(slide: Sprite2D) -> Signal:
	var tween = create_tween()
	tween.tween_property(slide, "modulate:a", 1.0, fade_time)
	return tween.finished

func fade_out(slide: Sprite2D) -> Signal:
	var tween = create_tween()
	tween.tween_property(slide, "modulate:a", 0.0, fade_time)
	return tween.finished
