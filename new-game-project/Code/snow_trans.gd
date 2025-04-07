extends Node2D

@onready var marker_from_keeper = $Marker2D
@onready var marker_from_forest = $fromForest

func _ready():
	PlayerManager.Map_loco = "Keeper"
	var spawn_position: Vector2
	if PlayerManager.previous_location == "keeper":
		spawn_position = marker_from_keeper.global_position
	elif PlayerManager.previous_location == "forest":
		spawn_position = marker_from_forest.global_position
	else:
		spawn_position = marker_from_keeper.global_position # Fallback

	PlayerManager.spawn_player(self, spawn_position)
