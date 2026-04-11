# PlayerSaveData.gd
extends Resource
class_name PlayerSaveData

@export var total_stars_count: int = 0
@export var unlocked_levels: Dictionary = {}  # int -> уровень (НЕ строка!)

var max_stars = 3

func add_star(level_id: int) -> void:
	if unlocked_levels.is_empty():
		print_debug("Разблокированные уровни ", unlocked_levels)
		return
	
	if unlocked_levels.has(level_id):
		if unlocked_levels[level_id].has("stars_count"):
			var current_stars = unlocked_levels[level_id]["stars_count"]
			unlocked_levels[level_id]["stars_count"] = min(current_stars + 1, max_stars)
			total_stars_count += 1
			print_debug("---ИГРОК: Добавляем звезду! Теперь звезд: ", unlocked_levels[level_id]["stars_count"])

func add_kill(level_id: int, enemy_type: String) -> void:

	if unlocked_levels.has(level_id):
		if not unlocked_levels[level_id].has("killed"):
			unlocked_levels[level_id]["killed"] = {}
		
		if not unlocked_levels[level_id]["killed"].has(enemy_type):
			unlocked_levels[level_id]["killed"][enemy_type] = 0
		
		unlocked_levels[level_id]["killed"][enemy_type] += 1
		print("Убит %s! Всего: %d" % [enemy_type, unlocked_levels[level_id]["killed"][enemy_type]])

func add_score(level_id: int, score: int):

	if unlocked_levels.has(level_id):
		if not unlocked_levels[level_id].has("current_score"):
			unlocked_levels[level_id]["current_score"] = 0
		
		unlocked_levels[level_id]["current_score"] += score
		print("Добавлено очков: ", unlocked_levels[level_id]["current_score"])

func unlock_level(level_id: int) -> void:
	if level_id == -1:
		print("Ошибка: level_id не найден")
		return
	

	if not unlocked_levels.has(level_id):
		var level_data = {
			"stars_count": 0,
			"current_score": 0,
			"killed": {}
		}
		unlocked_levels[level_id] = level_data
		print_debug("Открыт уровень: ", level_id)

func is_level_unlocked(level_id: int) -> bool:

	return unlocked_levels.has(level_id)

func get_level_progress(level_id: int) -> Dictionary:
	if is_level_unlocked(level_id):
		print_debug("Информация об уровне: ", unlocked_levels[level_id])
		return unlocked_levels[level_id]
	return {}

func get_current_level_score(level_id: int) -> int:
	if is_level_unlocked(level_id):
		if unlocked_levels[level_id].has("current_score"):
			return unlocked_levels[level_id]["current_score"]
	return 0

func get_current_stars(level_id: int) -> int:
	if is_level_unlocked(level_id):
		return unlocked_levels[level_id]["stars_count"]
	return 0

func get_max_stars() -> int:
	return max_stars
