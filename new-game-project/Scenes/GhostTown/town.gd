extends Node2D

@onready var marker_from_waterfall = $fromWaterfall
@onready var marker_from_Gate = $fromGate

func _ready():
	var spawn_position: Vector2
	if PlayerManager.previous_location == "waterfall":
		spawn_position = marker_from_waterfall.global_position
	elif PlayerManager.previous_location == "Gate":
		spawn_position = marker_from_Gate.global_position
	else:
		spawn_position = marker_from_waterfall.global_position # Fallback

	PlayerManager.spawn_player(self, spawn_position)
