extends Node2D

@onready var marker_from_trail = $fromTrail
@onready var marker_from_ghostTown = null

func _ready():
	var spawn_position: Vector2
	if PlayerManager.previous_location == "trail":
		spawn_position = marker_from_trail.global_position
	elif PlayerManager.previous_location == "ghostTown":
		spawn_position = marker_from_ghostTown.global_position
	else:
		spawn_position = marker_from_trail.global_position # Fallback

	PlayerManager.spawn_player(self, spawn_position)
