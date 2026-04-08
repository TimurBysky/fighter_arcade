extends Resource
class_name PlayerSaveData

@export var total_stars_count: int = 0
@export var unlocked_levels: Dictionary = {}  # level_id -> уровень

var max_stars = 3

func get_player_data() -> Dictionary:
	var stats_to_load = {
		"total_stars_count": total_stars_count,
		"unlocked_levels": unlocked_levels,
	}
	return stats_to_load

func add_star(level_id: int) -> void:
	if unlocked_levels.is_empty():
		return
	
	for key in unlocked_levels:
		var level = unlocked_levels[key]
		if level.get("level_id", -1) == level_id:
			var current_stars = level.get("stars_count", 0)
			level["stars_count"] = min(current_stars + 1, max_stars)
			total_stars_count += 1
			break

func add_kill(level_id: int, enemy_type: String) -> void:
	var key = str(level_id)
	if unlocked_levels.has(key):
		if not unlocked_levels[key].has("killed"):
			unlocked_levels[key]["killed"] = {}
		
		if not unlocked_levels[key]["killed"].has(enemy_type):
			unlocked_levels[key]["killed"][enemy_type] = 0
		
		unlocked_levels[key]["killed"][enemy_type] += 1
		print("Убит %s! Всего: %d" % [enemy_type, unlocked_levels[key]["killed"][enemy_type]])

func add_score(level_id: int, score: int):
	var key = str(level_id)
	if unlocked_levels.has(key):
		if not unlocked_levels[key].has("current_score"):
			unlocked_levels[key]["current_score"] = {}
		
		unlocked_levels[key]["current_score"] += score
		print("Добавлено очков: ", unlocked_levels[key]["current_score"])

func unlock_level(level_id: int) -> void:
	# Получаем level_id из переданного словаря

	if level_id == -1:
		print("Ошибка: level_id не найден")
		return
	
	var level_data = {}
	level_data["stars_count"] = 0

	# Добавляем его в основной словарь
	unlocked_levels[level_id] = level_data
	# Если уровень уже был открыт, не увеличиваем счетчик
	if not is_level_unlocked(level_id):
		print("Уровень %d открыт!" % level_id)

func is_level_unlocked(level_id: int) -> bool:
	print_debug("ID Уровня: ",unlocked_levels.has(str(level_id)))
	return unlocked_levels.has(str(level_id))

func get_level_progress(level_id: int) -> Dictionary:
	if is_level_unlocked(level_id):
		print_debug("Информация об уровне: ",unlocked_levels[str(level_id)])
		return unlocked_levels[str(level_id)]
	return {}

func get_current_level_score(level_id: int) -> int:
	if is_level_unlocked(level_id):
		var key = str(level_id)
		if unlocked_levels.has(key):
			if unlocked_levels[key].has("current_score"):
				return unlocked_levels[key]["current_score"]
	return 0
