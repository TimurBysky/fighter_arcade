extends Node3D
@onready var health_bar = $Sprite3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_health(current_health: int, max_health: int) -> void:
	# Рассчитываем процент здоровья (от 0.0 до 1.0)
	health_bar.visible = true
	var health_percent = float(current_health) / float(max_health)
	
	# Применяем масштаб (исходный масштаб = 1.0)
	health_bar.scale.x = health_percent
	
	# Проверка на минимальный размер
	if health_percent <= 0.01:
		health_bar.visible = false
	
	# Меняем цвет
	if health_percent > 0.6:
		health_bar.modulate = Color.GREEN
	elif health_percent > 0.3:
		health_bar.modulate = Color.YELLOW
	else:
		health_bar.modulate = Color.RED
