# controllers/player_controller.gd
extends Node
#class_name PlayerController

# Это будет автозагрузка (Autoload)

var model: PlayerData
var view: Node
var shoot_cooldown: bool = false
var timer_shoot_bonus: Timer
var timer_extra_damage: Timer
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
func process_input() -> Vector3:
	if not view or not view.is_alive:
		return Vector3.ZERO
		
	var input_direction = Input.get_axis("ui_right", "ui_left")
	var movement = Vector3.ZERO
	movement.z = input_direction * model.speed
	return movement

func handle_shoot_input() -> void:
	if not view or not view.is_alive:
		return
		
	if Input.is_key_pressed(KEY_SPACE) and not shoot_cooldown and model.can_shoot(): #Стрельба
		shoot()

func shoot() -> void:
	shoot_cooldown = true
	model.consume_ammo()
	
	# Сообщаем view создать визуальный выстрел
	match(model.have_shoot_bonus):
		true:
			_shoot({"have_shoot_bonus": true, "damage_multiplier": model.damage_multypler})
		false:
			_shoot({"damage_multiplier": model.damage_multypler})
		
	if view.has_method("update_ammo_display"):
		view.update_ammo_display(model.current_ammo)
	
	# Задержка между выстрелами
	await get_tree().create_timer(model.fire_rate).timeout
	shoot_cooldown = false

func _shoot(params: Dictionary = {}) -> void:
	if view.has_method("shot_effect"):
		view.shot_effect(params)

func _activate_shoot_bonus():
	model.have_shoot_bonus = true
	if (timer_shoot_bonus):
		timer_shoot_bonus.stop()
	timer_shoot_bonus = Timer.new()
	add_child(timer_shoot_bonus)
	timer_shoot_bonus.start(5.0)
	timer_shoot_bonus.timeout.connect(_disable_shoot_bonus)

func _disable_shoot_bonus() -> void:
	model.have_shoot_bonus = false
	timer_shoot_bonus.queue_free()

func _activate_extra_damage(multypler: float = 2.0):
	model.damage_multypler = multypler
	if (timer_extra_damage):
		timer_extra_damage.stop()
	timer_extra_damage = Timer.new()
	add_child(timer_extra_damage)
	timer_extra_damage.start(5.0)
	timer_extra_damage.timeout.connect(_disable_extra_damage)

func _disable_extra_damage():
	model.reset_damage_multypler()
	timer_extra_damage.queue_free()

func handle_collision(other_body: Node) -> void:
	if not view or not view.is_alive:
		return
		
	# Логика обработки столкновений
	if other_body.is_in_group("Ammo"):
		model.add_ammo(60)
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
			
	elif other_body.is_in_group("shoot_bonus"):
		_activate_shoot_bonus()
		if view.has_method("bonus_take_effect"):
			view.bonus_take_effect()
			
	elif other_body.is_in_group("extra_damage"):
		_activate_extra_damage(other_body.bonus_damage_multiplyer)
		if view.has_method("bonus_take_effect"):
			view.bonus_take_effect()
			
	elif other_body.is_in_group("Enemy"):
		model.take_damage(1)
		if view.has_method("update_health_display"):
			view.update_health_display(model.current_health, model.max_health)
		if view.has_method("play_hit_effect"):
			view.play_hit_effect()
	elif other_body.is_in_group("bullets"):
		model.take_damage(1)
		if view.has_method("update_health_display"):
			view.update_health_display(model.current_health, model.max_health)
		if view.has_method("play_hit_effect"):
			view.play_hit_effect()
	
	# Уничтожаем объект, с которым столкнулись
	print_debug("Столкновение с ",other_body, " слой : ", other_body.collision_layer)
	
	if other_body.has_method("destroy"):
		other_body.destroy()

func _on_player_died() -> void:
	if view and view.has_method("destroy"):
		view.destroy()
	player_destroyed.emit()


func _on_player_respawned() -> void:
	if view and view.has_method("respawn"):
		view.respawn()

func reset():
	model.respawn()
# Для тестирования
#func destroy() -> void:
	#if view and view.has_method("destroy"):
		#view.destroy()
