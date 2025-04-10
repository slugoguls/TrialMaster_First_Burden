extends Node2D

@onready var creds_node := $Creds
@onready var fade_rect := $ColorRect
@export var fade_time := 3

func _ready():
	# Start fully black and hide content initially
	fade_rect.color.a = 1.0
	creds_node.modulate.a = 0.0
	
	# Fade in background and text
	await fade_in()
	
func fade_in() -> Signal:
	var tween = create_tween()
	tween.parallel().tween_property(fade_rect, "color:a", 0.0, fade_time)
	tween.parallel().tween_property(creds_node, "modulate:a", 1.0, fade_time)
	return tween.finished
