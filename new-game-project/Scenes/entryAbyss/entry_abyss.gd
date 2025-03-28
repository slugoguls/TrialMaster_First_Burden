extends Node2D

@onready var marker = $fromForest

func _ready():
	PlayerManager.previous_location = "abyss"
	var spawn_position = marker.global_position
	PlayerManager.spawn_player(self, spawn_position)
