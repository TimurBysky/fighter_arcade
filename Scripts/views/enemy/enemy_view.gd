extends CharacterBody3D
class_name EnemyView

@onready var area3D = $Area3D
@onready var ui = $HealthBar
var controller: EnemyController


var is_alive = true


func _ready() -> void:
	controller = EnemyController.new()
	add_child(controller)
	
	area3D.body_entered.connect(controller.handle_collision)
	controller.take_damage.connect(update_health_bar)
	
	var model = EnemyFactory.create_enemy()
	controller.setup(self, model)
	
	collision_mask = 0
	collision_layer = 2
	area3D.collision_mask = 2
	 
func _process(delta: float) -> void:

	if not is_alive:
		return
		
	velocity = controller.moving()
	move_and_slide()
	
func update_health_bar(current_health: int, max_health: int):
	ui.update_health(current_health, max_health)
	
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
