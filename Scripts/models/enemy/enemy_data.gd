extends Resource
class_name EnemyData

@export var speed = 5.0
@export var max_health: int = 5
@export var enemy_type: String = "enemy_light_plane"
var current_health: int

signal health_changed(amount: int)
signal enemy_died(enemy_type: String)

func _init():
	current_health = max_health

# Если вы используете .tres файлы, нужно переопределять текущее здоровье
func reset():
	current_health = max_health


func take_damage(amount: int = 1) -> void:
	if (current_health <=0):
		return
		
	current_health -= amount
	
	health_changed.emit(amount)

	if (current_health <=0):
		die()

func die():
	enemy_died.emit(enemy_type)
