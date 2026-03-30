# models/level/level_progress_data.gd
extends Resource
class_name LevelProgressData

@export var level_id: int = 0
@export var is_unlocked: bool = false
@export var stars_earned: int = 0
@export var best_score: int = 0
@export var best_time: float = 0.0
@export var times_completed: int = 0

# Прогресс целей для этого уровня
@export var goal_progress: Dictionary = {}  # "enemy_light_plane_killed": 5, "parts_collected": 0

func update_goal(goal_name: String, amount: int = 1) -> void:
	if not goal_progress.has(goal_name):
		goal_progress[goal_name] = 0
	goal_progress[goal_name] += amount

func get_goal_progress(goal_name: String) -> int:
	return goal_progress.get(goal_name, 0)

func reset_goals() -> void:
	goal_progress.clear()
