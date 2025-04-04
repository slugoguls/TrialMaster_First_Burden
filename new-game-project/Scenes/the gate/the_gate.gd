extends Node2D

@onready var marker_from_Town = $FromTown
@onready var marker_from_TrialGround= $FromTrialGround

func _ready():
	var spawn_position: Vector2
	if PlayerManager.previous_location == "Town":
		spawn_position = marker_from_Town.global_position
	elif PlayerManager.previous_location == "TrialGround":
		spawn_position = marker_from_TrialGround.global_position
	else:
		spawn_position = marker_from_Town.global_position # Fallback

	PlayerManager.spawn_player(self, spawn_position)
