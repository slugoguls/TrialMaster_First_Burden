extends Area2D

@onready var personright = $"../personright"


func _on_body_entered(body):
	if body.is_in_group("player"):
		personright.visible = false
