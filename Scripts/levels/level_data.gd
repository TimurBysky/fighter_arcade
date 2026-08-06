extends Resource
class_name LevelData

const SPAWN_POSITIONS = {
	"left": Vector3(-27, 0,-8),
	"left2": Vector3(-27, 0,-4),
	"center": Vector3(-27, 0, 0),
	"right2": Vector3(-27, 0, 4),
	"right": Vector3(-27, 0, 8)
}

@export var level_id: int
@export var level_name: String = "Уровень"
@export var level_scene: String = "res://Scripts/levels/level_scenes/level_1.tscn"
@export var spawn_interval: float = 2.0
@export var max_score: int = 1000
@export var stars_to_unlock: int = 0
@export var time_to_game_over: float = 10.0
@export var object_list = {
	"enemy_light_plane": {"chance" : 60, "scene": "res://Scenes/enemy.tscn"},
	"ammo_crate" : {"chance" : 20, "scene": "res://Scenes/ammo.tscn"},
	"health_pill": {"chance" : 20, "scene": "res://Scenes/health.tscn"}
}

func get_level_id() -> int:
	return level_id
	
func get_level_name() -> String:
	return level_name

func get_level_time_to_game_over():
	return time_to_game_over

func get_level_max_score():
	return max_score
	
func get_stars_for_unlock():
	return stars_to_unlock
	
func get_level_scene() -> String:
	return level_scene

func get_objects() -> Dictionary:
	return object_list

func get_spawn_positions() -> Dictionary:
	return SPAWN_POSITIONS
