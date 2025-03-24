extends Node2D

@onready var marker = $FromSnowTrans

func _ready():
	if GLobal.first_load == false:
		var spawn_position = marker.global_position
		PlayerManager.spawn_player(self, spawn_position)
