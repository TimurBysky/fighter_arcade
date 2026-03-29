# models/level/level_progress_data.gd
extends Resource
class_name LevelProgressData

# Данные о прохождении уровня
@export var level_id: int = 0
@export var is_unlocked: bool = false
@export var stars_earned: int = 0  # 0-3
@export var best_score: int = 0
@export var best_time: float = 0.0
@export var times_completed: int = 0
@export var last_played: String = ""  # дата последнего прохождения

func complete_level(stars: int, score: int, time: float) -> void:
	if stars > stars_earned:
		stars_earned = stars
	
	if score > best_score:
		best_score = score
	
	if best_time == 0 or time < best_time:
		best_time = time
	
	times_completed += 1
	last_played = Time.get_datetime_string_from_system()
	is_unlocked = true

func unlock() -> void:
	is_unlocked = true
