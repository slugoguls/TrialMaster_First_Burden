extends Node2D


const speed = 250


func _process(delta: float) -> void:
	var axis = Input.get_axis("ui_left", "ui_right")
	position.x += axis * speed * delta
