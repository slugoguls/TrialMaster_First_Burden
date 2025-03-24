extends Area2D

@onready var personright = $"../personright"

func _ready():
	personright.visible = false

func _on_body_entered(body):
	if body.is_in_group("player") && GLobal.interacted_with_keeper:
		personright.visible = true
