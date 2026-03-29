extends Resource
class_name PlayerStatsData

@export var enemy_kill_count: int = 0
@export var total_score:int = 0
var completed_levels: int = 0

signal score_changed
signal kill_count_changed
signal completed_levels_changed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_kill() -> void:
	enemy_kill_count += 1
	kill_count_changed.emit(enemy_kill_count)

func add_score(amount: int = 10):
	total_score += amount
	score_changed.emit(total_score)

func add_complete_level():
	completed_levels += 1
	completed_levels_changed.emit(completed_levels)
