# controllers/level_controller.gd
extends Node

@onready var main_menu = get_node("/root/MainMenuController")
var spawn_timer: Timer

signal level_selected(level_data: LevelData)
signal level_completed(level_id: int, stars: int)
signal levels_loaded(levels: Array)

var current_level_data: LevelData
var current_level_view: Node
var player: Node
var all_levels: Array[LevelData] = []


func _ready() -> void:
	load_all_levels()
	
	
func start_timer():
	spawn_timer = Timer.new()
	spawn_timer.timeout.connect(_create_object)
	spawn_timer.wait_time = current_level_data.spawn_interval
	spawn_timer.autostart = true
	add_child(spawn_timer)

func _create_object():
	if not is_instance_valid(current_level_view):
			return
	
	if current_level_view.has_method("create_object"):
		current_level_view.create_object()
	

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
					#print("Загружен уровень: ", level_data.get_level_info().values()[0]["level_name"])
			
			file_name = dir.get_next()
		
		dir.list_dir_end()
	
	# Сортируем по ID
	all_levels.sort_custom(func(a, b): 
		return a.get_level_id() < b.get_level_id()
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
	var level_name = level_data.get_level_name()
	print("START LEVEL: ", level_name)
	print("SCENE PATH: ", level_data.level_scene)
	get_tree().change_scene_to_file(level_data.level_scene)
	start_timer()

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

func exit_to_mani_menu():
	get_tree().change_scene_to_file(main_menu.get_main_menu_scene())

func register_enemy(enemy_controller: EnemyController) -> void:
	if not enemy_controller:
		print("Ошибка: enemy_controller = null")
		return
	
	if not enemy_controller.enemy_destroy.is_connected(_on_enemy_killed):
		enemy_controller.enemy_destroy.connect(_on_enemy_killed)
		print_debug("Сигнал подключен")
	
func calculate_stars() -> int:
	var level_id = current_level_data.get_level_id()
	var current_score = SaveMenager.get_current_score(level_id)
	var max_score = current_level_data.get_level_max_score()
	print_debug("Текущие очки(для просчёта звёзд): ", current_score)
	
	var step = max_score / 3.0
	
	if current_score >= max_score:
		return 3
	elif current_score >= step * 2:
		return 2
	elif current_score >= step:
		return 1
	else:
		return 0

func _on_enemy_killed(enemy_type: String, score: int):
	print_debug("Враг убит!")
	var level_id = current_level_data.get_level_id()
	SaveMenager.add_kill(level_id, enemy_type)
	SaveMenager.add_score(level_id, score)
	
	var stars = calculate_stars()
	var current_stars = SaveMenager.get_current_stars(level_id)
	var max_stars = SaveMenager.get_max_stars()
	
	# Обновляем только если звезд стало больше
	if current_stars < max_stars:
		if stars > current_stars:
			for i in range(stars - current_stars):
				SaveMenager.add_star(current_level_data.get_level_id())
				print_debug("ДОБАВЛЕНА ЗВЕЗДА! Кол-во звёзд на уровне: ",  current_stars)
		
	SaveMenager.save_game()


func _on_player_destroyed() -> void:
	await get_tree().create_timer(1.0).timeout
	if current_level_view and current_level_view.has_method("show_defeat_screen"):
		current_level_view.show_defeat_screen()

func complete_level(stars: int) -> void:
	if current_level_data:
		var level_id = current_level_data.get_level_id()
		level_completed.emit(level_id, stars)
