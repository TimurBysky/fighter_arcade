# controllers/save_manager.gd (Autoload)
extends Node


var save_data: PlayerSaveData
const SAVE_PATH = "res://Saves/"

func _ready() -> void:
	load_game()

func load_game() -> void:
	if ResourceLoader.exists(SAVE_PATH):
		save_data = load(SAVE_PATH)
	else:
		save_data = PlayerSaveData.new()
		save_data.unlocked_levels = {}  # инициализация

func save_game() -> void:
	ResourceSaver.save(save_data, SAVE_PATH)

func unlock_level(level_id: int, level_name: String) -> void:
	var level_info = {
		"level_id": level_id,
		"level_name": level_name,
		"stars_count": 0
	}
	save_data.unlock_level(level_info)  # передаем словарь
	save_game()

func add_star(level_id: int) -> void:
	save_data.add_star(level_id)
	save_game()

func is_level_unlocked(level_id: int) -> bool:
	return save_data.is_level_unlocked(level_id)
