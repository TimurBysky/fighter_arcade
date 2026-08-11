extends CharacterBody3D
class_name EnemyView

@export var current_model: EnemyData = load("res://Scripts/models/enemy/enemy_data.tres")
@onready var shoot_timer: Timer = $Shoot_timer
@onready var area3D = $Area3D
@onready var ui = $HealthBar
@onready var tracer_scene = preload("res://Scenes/tracer.tscn")
var controller: EnemyController

var is_alive = true


func _ready() -> void:
	controller = EnemyController.new()
	add_child(controller)
	
	area3D.body_entered.connect(controller.handle_collision)
	controller.take_damage.connect(update_health_bar)
	
	var model = EnemyFactory.create_enemy(current_model)
	controller.setup(self, model)
	
	collision_mask = 0
	collision_layer = 2
	area3D.collision_mask = 4
	 
func _process(delta: float) -> void:

	if not is_alive:
		return
		
	velocity = controller.moving()
	move_and_slide()
	
func update_health_bar(current_health: int, max_health: int):
	ui.update_health(current_health, max_health)
	
func shooting_effect():
	var angle = 180

	var instance = tracer_scene.instantiate() as Tracer
	var angle_rad = deg_to_rad(angle)
	
	# Движение влево с отклонением по Z (горизонталь)
	var direction = Vector3(-cos(angle_rad), 0, sin(angle_rad))
	direction = direction.normalized()
	
	instance.direction = direction
	add_child(instance)
	instance.shoot_by_("enemy")

func spread_shooting_effect():
	var angles = [-205, -155]
		
	for angle in angles:
		var instance = tracer_scene.instantiate() as Tracer
		var angle_rad = deg_to_rad(angle)
		
		# Движение влево с отклонением по Z (горизонталь)
		var direction = Vector3(-cos(angle_rad), 0, sin(angle_rad))
		direction = direction.normalized()
		
		instance.direction = direction
		add_child(instance)
		instance.shoot_by_("enemy")

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
