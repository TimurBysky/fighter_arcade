# controllers/level_controller.gd
extends Node

signal level_selected(level_data: LevelData)
signal level_completed(level_id: int, stars: int)
signal levels_loaded(levels: Array)

var current_level_data: LevelData
var current_level_view: Node
var player: Node
var all_levels: Array[LevelData] = []

func _ready() -> void:
	load_all_levels()

func load_all_levels() -> void:
	all_levels.clear()
	
	# Сканируем папку с .tres файлами уровней
	var dir = DirAccess.open("res://Scripts/levels/level_scenes/")
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if file_name.ends_with(".tres") and file_name != "level_data.tres":
				var level_path = "res://Scripts/levels/level_scenes/" + file_name
				var level_data = load(level_path)
				if level_data is LevelData:
					all_levels.append(level_data)
					print("Загружен уровень: ", level_data.get_level_info().values()[0]["level_name"])
			
			file_name = dir.get_next()
		
		dir.list_dir_end()
	
	# Сортируем по ID
	all_levels.sort_custom(func(a, b): 
		return a.get_level_info().values()[0]["level_id"] < b.get_level_info().values()[0]["level_id"]
	)
	print_debug("Загружены уровни: ", all_levels)
	levels_loaded.emit(all_levels)

func get_all_levels() -> Array[LevelData]:
	return all_levels

func setup(level_view: Node) -> void:
	current_level_view = level_view

func init_player(player_node: Node) -> void:
	player = player_node
	if player and player.has_signal("player_destroyed"):
		player.player_destroyed.connect(_on_player_destroyed)

func start_level(level_data: LevelData) -> void:
	current_level_data = level_data
	var info = level_data.get_level_info().values()[0]
	print("START LEVEL: ", info["level_name"])
	print("SCENE PATH: ", level_data.level_scene)
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
		var level_info = current_level_data.get_level_info().values()[0]
		var level_id = level_info["level_id"]
		level_completed.emit(level_id, stars)
