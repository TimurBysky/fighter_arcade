extends CharacterBody3D
class_name EnemyView

@export var current_model: EnemyData = load("res://Scripts/models/enemy/enemy_data.tres")
@onready var shoot_timer: Timer = $Shoot_timer
@onready var area3D = $Area3D
@onready var ui = $HealthBar
@onready var tracer_scene = preload("res://Scenes/tracer.tscn")
@onready var explode_scene = preload("res://Scenes/explode.tscn")
@onready var destroy_sounds = [$Destroy_1, $Destroy_2, $Destroy_3]

var controller: EnemyController

var is_alive = true
#var is_boss = false
var amplitude: float = 7.0      # Насколько далеко влево/вправо
var speed: float = 2.0          # Скорость качания
var start_position: Vector3
var time: float = 0.0
var max_tilt_angle: float = 15.0 
var explosion_timer: Timer

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
	
		
	start_position = global_position
	 
func _process(delta: float) -> void:

	if not is_alive:
		return
	
	if controller.moving_glide():
		move_glide(delta)
	
	velocity = controller.moving()
	move_and_slide()
	
func update_health_bar(current_health: int, max_health: int):
	ui.update_health(current_health, max_health)
	
func shooting_effect():
	var angle = 180

	var instance = tracer_scene.instantiate() as Tracer
	var angle_rad = deg_to_rad(angle)
	instance.global_position = global_position
	
	# Движение влево с отклонением по Z (горизонталь)
	var direction = Vector3(-cos(angle_rad), 0, sin(angle_rad))
	direction = direction.normalized()
	
	instance.direction = direction
	get_tree().current_scene.add_child(instance)
	instance.shoot_by_("enemy")

func spread_shooting_effect():

		
	var angles = [-200, -160]
	
	if current_model.is_boss:
		angles = [-198, -162]
		
	for angle in angles:
		var instance = tracer_scene.instantiate() as Tracer
		var angle_rad = deg_to_rad(angle)
		instance.global_position = global_position
		# Движение влево с отклонением по Z (горизонталь)
		var direction = Vector3(-cos(angle_rad), 0, sin(angle_rad))
		direction = direction.normalized()
		
		instance.direction = direction
		get_tree().current_scene.add_child(instance)
		instance.shoot_by_("enemy")

func move_glide(delta: float):
	time += delta * speed
	global_position.z = start_position.z + sin(time) * amplitude
	
	# Добавляем наклон (крен) по оси X
	var target_tilt = cos(time) * max_tilt_angle 
	rotation_degrees.z = -target_tilt
	
func get_hp():
	return current_model.current_health
	
func get_max_hp():
	return current_model.max_health
	
func destroy():
	if not is_alive:
		return
		
	is_alive = false
	
	if !current_model.is_boss():
		
		var chosen_sound = destroy_sounds.pick_random()
	
	# Если звук существует, проигрываем его
		if chosen_sound and chosen_sound.stream:
			chosen_sound.play()
			
		var instance = explode_scene.instantiate()
		add_child(instance)
		
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
		return
	
# Смерть БОССА
	if has_node("Shoot_timer"):
		$Shoot_timer.stop()
	
	var spin_direction = 1.0 if randf() > 0.5 else -1.0
	var spin_on_x = randf() > 0.5
	
	# --- НАСТРОЙКА ТАЙМЕРА ВЗРЫВОВ ---
	explosion_timer = Timer.new()
	explosion_timer.wait_time = 0.5 # Взрыв каждые 0.5 секунды
	explosion_timer.timeout.connect(_spawn_explosion_at_boss)
	add_child(explosion_timer)
	explosion_timer.start()
	
	# Первый взрыв сразу
	_spawn_explosion_at_boss()
	
	# --- АНИМАЦИЯ ПАДЕНИЯ ---
	var tween = create_tween()
	
	# 1. Зависание (шок)
	tween.tween_interval(2.0)
	
	# 2. Падение вниз
	tween.tween_property(self, "global_position:y", self.global_position.y - 40.0, 20.0)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	# 3. Летит вперёд
	tween.parallel().tween_property(self, "global_position:x", self.global_position.x + 40.0, 20.0)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# 4. Вращение по случайной оси
	if spin_on_x:
		tween.parallel().tween_property(self, "rotation_degrees:x", 
			rotation_degrees.x + 360.0 * spin_direction * 6.0, 20.0)\
			.set_trans(Tween.TRANS_LINEAR)
	else:
		tween.parallel().tween_property(self, "rotation_degrees:z", 
			rotation_degrees.z + 360.0 * spin_direction * 6.0, 20.0)\
			.set_trans(Tween.TRANS_LINEAR)
	
	# 5. Наклон по Y (штопор)
	tween.parallel().tween_property(self, "rotation_degrees:y", 
		rotation_degrees.y + 180.0 * spin_direction, 20.0)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# 6. Исчезновение (начинается за 3 секунды до конца)
	tween.tween_interval(7.0) 
	tween.tween_property(self, "modulate:a", 0.0, 3.0)
	
	# 7. Остановка таймера и удаление
	tween.tween_callback(_stop_explosions)
	tween.tween_interval(0.5)
	tween.tween_callback(queue_free)


func _spawn_explosion_at_boss():
	# Защита: если босс уже удален, не создаем взрыв
	if not is_instance_valid(self): return 
	
	var chosen_sound = destroy_sounds.pick_random()
	
	# Если звук существует, проигрываем его
	if chosen_sound and chosen_sound.stream:
		chosen_sound.play()
	
	var explosion = explode_scene.instantiate()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = global_position
	
	# Небольшой рандом, чтобы взрывы не появлялись строго в одной точке
	explosion.global_position += Vector3(
		randf_range(-3.5, 3.5), 
		randf_range(-3.5, 3.5), 
		randf_range(-3.5, 3.5)
	)

func _stop_explosions():
	if is_instance_valid(explosion_timer):
		explosion_timer.stop()
		explosion_timer.queue_free()
