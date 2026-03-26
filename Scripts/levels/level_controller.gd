extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
