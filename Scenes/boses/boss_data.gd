extends Resource
class_name BossData

@export var max_health: int = 100
@export var boss_name: String = "boss"
@export var behavior_pattern: Array
var health: int
var is_alive: bool = true
var current_behavior_pattern: Script
var current_behavior_index: int = 0
var max_pattern_index: int

func init():
	health = max_health
	if behavior_pattern.is_empty():
		return
	current_behavior_pattern = behavior_pattern[current_behavior_index]
	max_pattern_index = behavior_pattern.size()
	
func take_damage(amount: int = 1):
	if !is_alive:
		return
	
	health -= amount
	
	if health <= 0:
		is_alive = false

func heal(amount: int = 1):
	if !is_alive:
		return
	health = min(health + amount, max_health)

func change_behavior_pattern():
	if !is_alive:
		return
		
	if behavior_pattern.is_empty():
		return
	
	current_behavior_index = get_next_index(current_behavior_index, max_pattern_index)
	current_behavior_pattern = behavior_pattern[current_behavior_index]

func get_next_index(current: int, max: int) -> int:
	return (current + 1) % (max + 1)  # % = остаток от деления (работает как круг)
