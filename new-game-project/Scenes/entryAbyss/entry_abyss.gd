extends Node2D

@onready var marker_from_forest = $fromForest
@onready var marker_from_trial = $fromTrial

func _ready():
	PlayerManager.Map_loco = "Forest"
	var spawn_position: Vector2
	if PlayerManager.previous_location == "forest":
		spawn_position = marker_from_forest.global_position
	elif PlayerManager.previous_location == "trial":
		spawn_position = marker_from_trial.global_position
	else:
		spawn_position = marker_from_forest.global_position # Fallback

	PlayerManager.spawn_player(self, spawn_position)
