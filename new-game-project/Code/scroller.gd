extends Node2D

const speed = 75

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var axis = Input.get_axis("ui_left", "ui_right")
	position.x += axis * delta * speed
