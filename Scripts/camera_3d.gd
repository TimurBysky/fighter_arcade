extends Camera3D
@onready var fighter = $"../CharacterBody3D/Fighter_Model"
@onready var player_view: PlayerView = $".."

@export var speed = 3.0
@export var offest = Vector3(2, 2, 0)
@export var fall_zoom_fov = 50.0 

# --- Настройки тряски ---
@export var base_fov: float = 75.0
@export var shake_intensity: float = 0.1
@export var shake_duration: float = 0.15

# --- Настройки падения ---
@export var fall_rotate_speed: float = 2.0 # Скорость поворота камеры за самолётом

var shake_time_left: float = 0.0
var is_falling: bool = false

func _ready() -> void:
	base_fov = fov

func _process(delta: float) -> void:
	if not player_view.is_alive and not is_falling:
		start_fall_camera()

	if is_falling:
		# Плавно поворачиваем камеру в сторону самолёта
		var target_basis = Basis.looking_at(fighter.global_position - global_position, Vector3.UP)
		# Интерполируем текущий базис к целевому
		global_transform.basis = global_transform.basis.slerp(target_basis, fall_rotate_speed * delta)
	else:
		# Обычное слежение с задержкой
		var target_pos = fighter.global_position + offest
		global_position = global_position.lerp(target_pos, speed * delta)

	# Тряска
	if shake_time_left > 0.0:
		shake_time_left -= delta
		h_offset = randf_range(-shake_intensity, shake_intensity)
		v_offset = randf_range(-shake_intensity, shake_intensity)
	else:
		h_offset = lerp(h_offset, 0.0, 15.0 * delta)
		v_offset = lerp(v_offset, 0.0, 15.0 * delta)

func start_fall_camera():
	is_falling = true
	
	var tween = create_tween()
	tween.set_parallel(true)
	
	# Приближение
	tween.tween_property(self, "fov", fall_zoom_fov, 1.5).set_trans(Tween.TRANS_SINE)
	
	# Отодвигаем камеру назад и вверх (чтобы видеть всё падение)
	var look_pos = fighter.global_position
	var back_dir = (global_position - look_pos).normalized()
	var target_pos = look_pos + back_dir * 15.0
	target_pos.y += 5.0
	tween.tween_property(self, "global_position", target_pos, 1.5).set_trans(Tween.TRANS_SINE)

func trigger_shake():
	shake_time_left = shake_duration
