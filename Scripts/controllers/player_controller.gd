# controllers/player_controller.gd
extends Node
#class_name PlayerController

# Это будет автозагрузка (Autoload)

var model: PlayerData
var view: Node
var shoot_cooldown: bool = false

# Сигналы для других систем
signal player_destroyed

func setup(player_view: Node, player_model: PlayerData) -> void:
	view = player_view
	model = player_model
	
	# Подключаем сигналы модели
	model.player_died.connect(_on_player_died)
	model.player_respawned.connect(_on_player_respawned)
	
	# Настраиваем view
	if view.has_method("update_health_display"):
		view.update_health_display(model.current_health, model.max_health)
	if view.has_method("update_ammo_display"):
		view.update_ammo_display(model.current_ammo)

# Обработка ввода (логика управления)
func process_input(delta: float) -> Vector3:
	if not view or not view.is_alive:
		return Vector3.ZERO
		
	var input_direction = Input.get_axis("ui_right", "ui_left")
	var movement = Vector3.ZERO
	movement.z = input_direction * model.speed
	return movement

func handle_shoot_input() -> void:
	if not view or not view.is_alive:
		return
		
	if Input.is_key_pressed(KEY_SPACE) and not shoot_cooldown and model.can_shoot():
		shoot()

func shoot() -> void:
	shoot_cooldown = true
	model.consume_ammo()
	
	# Сообщаем view создать визуальный выстрел
	if view.has_method("create_shot_effect"):
		view.create_shot_effect()
	if view.has_method("update_ammo_display"):
		view.update_ammo_display(model.current_ammo)
	
	# Задержка между выстрелами
	await get_tree().create_timer(model.fire_rate).timeout
	shoot_cooldown = false

func handle_collision(other_body: Node) -> void:
	if not view or not view.is_alive:
		return
		
	# Логика обработки столкновений
	if other_body.is_in_group("Ammo"):
		model.add_ammo(30)
		if view.has_method("update_ammo_display"):
			view.update_ammo_display(model.current_ammo)
		if view.has_method("play_pickup_sound"):
			view.play_pickup_sound()
			
	elif other_body.is_in_group("Health"):
		model.heal(1)
		if view.has_method("update_health_display"):
			view.update_health_display(model.current_health, model.max_health)
		if view.has_method("play_heal_effect"):
			view.play_heal_effect()
			
	elif other_body.is_in_group("Enemy"):
		model.take_damage(1)
		if view.has_method("update_health_display"):
			view.update_health_display(model.current_health, model.max_health)
		if view.has_method("play_hit_effect"):
			view.play_hit_effect()
	
	# Уничтожаем объект, с которым столкнулись
	if other_body.has_method("destroy"):
		other_body.destroy()

func _on_player_died() -> void:
	if view and view.has_method("destroy"):
		view.destroy()
	player_destroyed.emit()

func _on_player_respawned() -> void:
	if view and view.has_method("respawn"):
		view.respawn()

# Для тестирования
func destroy() -> void:
	if view and view.has_method("destroy"):
		view.destroy()
