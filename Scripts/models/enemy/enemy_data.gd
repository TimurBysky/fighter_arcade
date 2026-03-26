extends Resource
class_name EnemyData

@export var speed = 5.0
@export var max_health: int = 5
var current_health: int

signal health_changed(amount: int)
signal enemy_died

func _init():
	current_health = max_health

# Если вы используете .tres файлы, нужно переопределять текущее здоровье
func reset():
	current_health = max_health


func take_damage(amount: int = 1) -> void:
	current_health -= amount
	
	health_changed.emit(amount)

	if (current_health <=0):
		die()
	

	if current_health <= 0:
		die()
		
func die():
	enemy_died.emit()
