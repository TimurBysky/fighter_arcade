# controllers/save_manager.gd (Autoload)
extends Node

var save_data: PlayerSaveData
const SAVE_PATH = "user://save_data.tres"

signal data_updated

func _ready() -> void:
	load_game()

func load_game() -> void:
	if ResourceLoader.exists(SAVE_PATH):
		save_data = load(SAVE_PATH)
	else:
		save_data = PlayerSaveData.new()
		# Открываем первый уровень
		var first_level = load("res://Scripts/levels/level_scenes/level_1.tres")
		var level_info = first_level.get_level_info().values()[0]
		save_data.unlock_level(level_info)
		save_game()
	
	data_updated.emit()

func save_game() -> void:
	ResourceSaver.save(save_data, SAVE_PATH)

func unlock_level(level_data: LevelData) -> void:
	var level_info = level_data.get_level_info().values()[0]
	save_data.unlock_level(level_info)
	save_game()
	data_updated.emit()

func add_star(level_id: int) -> void:
	save_data.add_star(level_id)
	save_game()
	data_updated.emit()

func get_level_progress(level_id: int) -> Dictionary:
	return save_data.get_level_progress(level_id)

func get_total_stars() -> int:
	return save_data.total_stars_count

func is_level_unlocked(level_id: int) -> bool:
	return save_data.is_level_unlocked(level_id)
