extends Node
class_name EnemyController

var model: EnemyData
var view: Node
# Called when the node enters the scene tree for the first time.

signal enemy_destroy(enemy_type: String)
signal take_damage(current_health: int, max_health: int)

func setup(enemy_view: CharacterBody3D, enemy_model: EnemyData):
	model = enemy_model
	view = enemy_view
	
	model.enemy_died.connect(_on_enemy_died)
	
func moving() -> Vector3:
	var movement = Vector3.ZERO
	movement.x = model.speed
	
	return movement

func handle_collision(other_body: Node) -> void:
	if not view or not view.is_alive:
		return
		
	if(other_body.is_in_group("bullets")):
		model.take_damage(other_body.damage)
		take_damage.emit(model.current_health, model.max_health)
		if(other_body.has_method("destroy")):
			other_body.destroy()

func _on_enemy_died(enemy_type: String):
	if view.has_method("destroy"):
		view.destroy()
	enemy_destroy.emit(enemy_type)
