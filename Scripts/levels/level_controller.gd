extends Node
@onready var player: Node

var view: Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func setup(level_view: Node):
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

func _level_restart() -> void:
	await get_tree().create_timer(1.0).timeout
	if(view.has_method("show_defeat_screen")):
		view.show_defeat_screen()
