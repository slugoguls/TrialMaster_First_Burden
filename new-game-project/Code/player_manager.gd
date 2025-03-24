extends Node

var player_scene = preload("res://character/monklol.tscn")
var player_instance: CharacterBody2D = null
var last_position: Vector2 = Vector2.ZERO

func spawn_player(parent: Node, position: Vector2):
	# Check if player already exists
	if player_instance:
		player_instance.global_position = position
		parent.add_child(player_instance)  # Reparent it to the new scene
	else:
		# Instantiate and spawn player if not already created
		player_instance = player_scene.instantiate()
		parent.add_child(player_instance)
		player_instance.global_position = position

func save_position():
	if player_instance:
		last_position = player_instance.global_position
