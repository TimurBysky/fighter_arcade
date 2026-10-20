extends Camera3D
@onready var fighter = $"../CharacterBody3D/Fighter_Model"

@export var speed = 3.0
@export var offest = Vector3(2, 2, 0)

# --- Настройки тряски и зума ---
@export var base_fov: float = 75.0
@export var shake_intensity: float = 0.1
@export var shake_duration: float = 0.15


var shake_time_left: float = 0.0


func _ready() -> void:
	base_fov = fov

func _process(delta: float) -> void:
	# 1. Слежение за игроком (как было)
	var target_pos = fighter.global_position + offest
	global_position = global_position.lerp(target_pos, speed * delta)

	# 2. Тряска (через смещение обзора, а не позиции!)
	if shake_time_left > 0.0:
		shake_time_left -= delta
		h_offset = randf_range(-shake_intensity, shake_intensity)
		v_offset = randf_range(-shake_intensity, shake_intensity)
	else:
		h_offset = lerp(h_offset, 0.0, 15.0 * delta)
		v_offset = lerp(v_offset, 0.0, 15.0 * delta)

# --- Вызывай эти функции при стрельбе ---

func trigger_shake():
	# Перезапускаем таймер (если стреляют очередью, тряска не будет прерываться)
	shake_time_left = shake_duration
