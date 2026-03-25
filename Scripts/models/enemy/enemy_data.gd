extends Resource
class_name EnemyData

@export var speed = 5.0
@export var health = 5

signal health_changed(amount: int)
signal enemy_died

func take_damage(amount: int = 1) -> void:
	health -= amount
	health_changed.emit(amount)

	if health <= 0:
		die()
		
func die():
	enemy_died.emit()
