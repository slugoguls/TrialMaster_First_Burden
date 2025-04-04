extends Node2D

@onready var marker_from_Gate = $FromGate

func _ready():
	var spawn_position: Vector2
	if PlayerManager.previous_location == "Gate":
		spawn_position = marker_from_Gate.global_position
		
	PlayerManager.spawn_player(self, spawn_position)
