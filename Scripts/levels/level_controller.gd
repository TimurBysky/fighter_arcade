extends Node
@onready var player: Node

var all_levels: Array[LevelData] = []
var level_progress: Dictionary = {}  # level_id -> LevelProgressData
var current_level: LevelData = null
var view: Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func setup(level_view: Node):
	var level_data = LevelData.new()
	view = level_view

func init_player(player_node: Node) -> void:
	player = player_node
	player.player_destroyed.connect(_level_restart)

func get_random_position(SPAWN_POSITIONS: Dictionary) -> Vector3:
	var positions = SPAWN_POSITIONS.values()
	return positions[randi() % positions.size()]

func get_random_object_with_chance(objects_dict: Dictionary) -> String:
	# objects_dict = {
	#     "enemy": {"chance": 60, "scene": enemy_scene},
	#     "health": {"chance": 25, "scene": health_scene},
	#     "ammo": {"chance": 15, "scene": ammo_scene}
	# }
	
	var random_value = randi() % 100  # 0-99
	var cumulative = 0
	
	for object_type in objects_dict: 
		var chance = objects_dict[object_type]["chance"]
		cumulative += chance
		
		if random_value < cumulative:
			return object_type
	
	# Если ничего не выбрано (ошибка), возвращаем первый
	return objects_dict.keys()[0]
	
func load_all_levels():
	
	var level_files = scan_levels_folder()
	
	for i in range(level_files.size()):
		var level_data = LevelData.new()
		level_data.level_id = i + 1
		level_data.level_name = "Уровень %d" % (i + 1)
		level_data.scene_path = level_files[i]
		
		# Для первого уровня ставим unlocked = true
		if i == 0:
			get_progress_for_level(level_data.level_id).is_unlocked = true
		
		all_levels.append(level_data)

func get_progress_for_level(level_id: int) -> LevelProgressData:
	if not level_progress.has(level_id):
		var progress = LevelProgressData.new()
		progress.level_id = level_id
		level_progress[level_id] = progress
	return level_progress[level_id]

func _level_restart() -> void:
	await get_tree().create_timer(1.0).timeout
	if(view.has_method("show_defeat_screen")):
		view.show_defeat_screen()

# controllers/level_controller.gd
func scan_levels_folder() -> Array:
	var dir = DirAccess.open("res://Scripts/levels/scenes/")
	var levels = []
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if file_name.ends_with(".tscn"):
				var level_data = LevelData.new()
				level_data.scene_path = "res://levels/" + file_name
				level_data.level_name = file_name.replace(".tscn", "").replace("_", " ")
				levels.append(level_data)
			
			file_name = dir.get_next()
		
		dir.list_dir_end()
	
	# Сортируем по имени
	levels.sort_custom(func(a, b): return a.level_name < b.level_name)
	return levels
