extends Node2D

@onready var marker = $Marker2D

func _ready():
	var spawn_position = PlayerManager.last_position if PlayerManager.last_position != Vector2.ZERO else marker.global_position
	PlayerManager.spawn_player(self, spawn_position)
