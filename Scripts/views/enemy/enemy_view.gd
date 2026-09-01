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
	
	var spin_direction = 1.0 if randf() > 0.5 else -1.0
	
	var tween = create_tween()
	
	# Падение вниз (дольше, но та же скорость)
	tween.tween_property(self, "global_position:y", self.global_position.y - 20.0, 4.0)
	
	# Летит вперёд по X+
	tween.parallel().tween_property(self, "global_position:x", self.global_position.x + 25.0, 4.0)
	
	# Вращение по оси X (кувырок, медленнее из-за большей длительности)
	tween.parallel().tween_property(self, "rotation_degrees:x", self.rotation_degrees.x + 360.0 * spin_direction * 3.0, 4.0)
	
	# Наклон вбок
	#tween.parallel().tween_property(self, "rotation_degrees:z", self.rotation_degrees.z + 45.0 * spin_direction, 4.0)
	
	# Исчезновение (начинается через 1 сек)
	tween.tween_interval(1.0)
	tween.tween_property(self, "modulate:a", 0.0, 3.0)
	
	# Удаление
	tween.tween_callback(queue_free)
