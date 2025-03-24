extends Node2D

@onready var marker = $Marker2D

func _ready():
	var spawn_position = marker.global_position
	PlayerManager.spawn_player(self, spawn_position)
