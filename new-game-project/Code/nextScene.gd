extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		PlayerManager.save_position()
		get_tree().change_scene_to_file("res://Scenes/SnowToTrail/snow_trans.tscn")
		GLobal.use_gravity = true
