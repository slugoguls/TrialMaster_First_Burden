extends Node2D

@onready var marker_from_snow = $fromSnow
@onready var marker_from_abyss = $fromAbyss

func _ready():
	var spawn_position: Vector2
	if PlayerManager.previous_location == "snow":
		spawn_position = marker_from_snow.global_position
	elif PlayerManager.previous_location == "abyss":
		spawn_position = marker_from_abyss.global_position
	else:
		spawn_position = marker_from_snow.global_position # Fallback

	PlayerManager.spawn_player(self, spawn_position)
