extends CharacterBody3D
class_name EnemyView

@onready var area3D = $Area3D
var controller: EnemyController


var is_alive = true


func _ready() -> void:
	controller = EnemyController.new()
	add_child(controller)
	
	area3D.body_entered.connect(controller.handle_collision)
	controller.enemy_destroy.connect(destroy)
	
	var original_model = load("res://Scripts/models/enemy/enemy_data.tres")
	var model = original_model.duplicate()
	controller.setup(self, model)
	
	collision_mask = 0
	collision_layer = 2
	area3D.collision_mask = 2
	 
func _process(delta: float) -> void:

	if not is_alive:
		return
		
	velocity = controller.moving()
	move_and_slide()
	
func destroy():
	if not is_alive:
		return
	
	is_alive = false
	
	var tween = create_tween()

	# Увеличиваемся
	tween.tween_property(self, "scale", Vector3(2.0, 2.0, 2.0), 0.3)\
			.set_ease(Tween.EASE_OUT)\
			.set_trans(Tween.TRANS_BACK)

	# Уменьшаемся до нормального размера
	tween.tween_property(self, "scale", Vector3.ONE, 0.3)\
			.set_ease(Tween.EASE_IN)\
			.set_trans(Tween.TRANS_ELASTIC)
	
	await tween.finished
	queue_free()
