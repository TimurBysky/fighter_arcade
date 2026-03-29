extends Resource
class_name LevelData

const SPAWN_POSITIONS = {
	"left": Vector3(-27, 0,-8),
	"left2": Vector3(-27, 0,-4),
	"center": Vector3(-27, 0, 0),
	"right2": Vector3(-27, 0, 4),
	"right": Vector3(-27, 0, 8)
}

@export var spawn_interval: float = 2.0
@export var level_id: int = 0
@export var level_name: String
@export var object_list = {
	"enemy_light_plane": {"chance" : 60, "scene": "res://Scenes/enemy.tscn"},
	"ammo_crate" : {"chance" : 20, "scene": "res://Scenes/ammo.tscn"},
	"health_pill": {"chance" : 20, "scene": "res://Scenes/health.tscn"}
}

func get_objects() -> Dictionary:
	return object_list

func get_spawn_positions() -> Dictionary:
	return SPAWN_POSITIONS

func get_level_id():
	return level_id
