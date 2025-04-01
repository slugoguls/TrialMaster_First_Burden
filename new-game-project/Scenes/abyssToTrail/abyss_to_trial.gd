extends Node2D

@onready var marker_from_abyss = $fromAbyss
@onready var marker_from_waterfall = $fromWaterfall

func _ready():
	var spawn_position: Vector2
	if PlayerManager.previous_location == "abyss":
		spawn_position = marker_from_abyss.global_position
	elif PlayerManager.previous_location == "waterfall":
		spawn_position = marker_from_waterfall.global_position
	else:
		spawn_position = marker_from_abyss.global_position # Fallback

	PlayerManager.spawn_player(self, spawn_position)
