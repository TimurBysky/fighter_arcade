extends GPUParticles3D

func _ready():
	# Настройки для кольца
	var mat = process_material as ParticleProcessMaterial
	
	mat.direction = Vector3(0, 0, 0)
	mat.spread = 90.0
	mat.flatness = 1.0  # Делает частицы плоскими (кольцо)
	mat.initial_velocity_min = 15.0
	mat.initial_velocity_max = 20.0
	
	# Настройка кривой размера (вспышка → затухание)
	var scale_curve = Curve.new()
	scale_curve.add_point(Vector2(0.0, 0.1))   # Рождение: почти невидим
	scale_curve.add_point(Vector2(0.1, 2.0))   # Вспышка!
	scale_curve.add_point(Vector2(0.5, 1.0))   # Затухание
	scale_curve.add_point(Vector2(1.0, 0.0))   # Исчезновение
	mat.scale_curve = scale_curve
	
	# Настройка градиента цвета (Белый → Прозрачный)
	var color_gradient = Gradient.new()
	color_gradient.add_point(0.0, Color(1, 1, 1, 1))     # Белый, непрозрачный
	color_gradient.add_point(0.2, Color(1, 1, 1, 0.8))   # Белый с прозрачностью
	color_gradient.add_point(0.5, Color(1, 1, 1, 0.4))   # Полупрозрачный
	color_gradient.add_point(1.0, Color(1, 1, 1, 0.0))   # Полностью прозрачный
	mat.color_ramp = color_gradient
	
	# Запускаем эмиссию
	emitting = true
	
	# Автоудаление после завершения анимации
	await get_tree().create_timer(lifetime).timeout
	queue_free()
