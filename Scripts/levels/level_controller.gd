# controllers/level_controller.gd
extends Node

signal level_completed(level_id: int, stars: int)

var current_level_data: LevelData
var current_level_view: Node
var player: Node

func setup(level_view: Node) -> void:
	current_level_view = level_view

func init_player(player_node: Node) -> void:
	player = player_node
	if player and player.has_signal("player_destroyed"):
		player.player_destroyed.connect(_on_player_destroyed)

func start_level(level_data: LevelData) -> void:
	current_level_data = level_data
	get_tree().change_scene_to_file(level_data.level_scene)

func get_current_level_data() -> LevelData:
	return current_level_data

func get_random_position(spawn_positions: Dictionary) -> Vector3:
	var positions = spawn_positions.values()
	return positions[randi() % positions.size()]

func get_random_object_with_chance(objects_dict: Dictionary) -> String:
	var random_value = randi() % 100
	var cumulative = 0
	
	for object_type in objects_dict:
		var chance = objects_dict[object_type]["chance"]
		cumulative += chance
		if random_value < cumulative:
			return object_type
	
	return objects_dict.keys()[0]

func _on_player_destroyed() -> void:
	await get_tree().create_timer(1.0).timeout
	if current_level_view and current_level_view.has_method("show_defeat_screen"):
		current_level_view.show_defeat_screen()

func complete_level(stars: int) -> void:
	if current_level_data:
		level_completed.emit(current_level_data.level_info.values()[0]["level_id"], stars)
