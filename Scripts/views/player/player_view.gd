# views/player/player_view.gd
extends Node3D
class_name PlayerView

# Ссылки на ноды
@onready var fighter: CharacterBody3D = $CharacterBody3D
@onready var fighter_model: Node3D = $CharacterBody3D/Fighter_Model
@onready var area_3d: Area3D = $CharacterBody3D/Area3D
@onready var tracer_scene = preload("res://Scenes/tracer.tscn")

# UI элементы (если есть)
@onready var health_label: Label = $"../UI/HealthLabel"
@onready var ammo_label: Label = $"../UI/AmmoLabel"

var is_alive: bool = true
var controller: PlayerController

func _ready() -> void:
	# Находим контроллер (autoload)
	controller = get_node("/root/PlayerController")
	
	# Подключаем сигналы Area3D
	area_3d.body_entered.connect(_on_body_entered)
	area_3d.collision_mask = 3 | 4
	
	# Регистрируем себя в контроллере
	var player_model = load("res://Scripts/models/player/player_data.tres")
	controller.setup(self, player_model)

func _process(delta: float) -> void:
	if not is_alive:
		return
		
	# Получаем движение от контроллера
	var movement = controller.process_input(delta)
	
	fighter.velocity = movement
	fighter.move_and_slide()
	
	# Ограничение движения
	var pos = fighter.global_position
	pos.z = clamp(pos.z, -11.0, 11.0)
	fighter.global_position = pos
	
	# Обработка стрельбы
	controller.handle_shoot_input()

# Визуальный эффект выстрела
func create_shot_effect() -> void:
	var instance = tracer_scene.instantiate()
	instance.global_position = fighter.global_position + Vector3(-1, 0, 0)
	add_child(instance)
	
	# Воспроизводим звук выстрела
	if $ShootSound:
		$ShootSound.play()

# Визуальный эффект попадания
func play_hit_effect() -> void:
	# Визуальная вспышка
	var tween = create_tween()
	tween.tween_property(fighter_model, "modulate", Color.RED, 0.1)
	tween.tween_property(fighter_model, "modulate", Color.WHITE, 0.1)
	
	# Звук попадания
	if $HitSound:
		$HitSound.play()

func play_heal_effect() -> void:
	var tween = create_tween()
	tween.tween_property(fighter_model, "modulate", Color.GREEN, 0.1)
	tween.tween_property(fighter_model, "modulate", Color.WHITE, 0.1)
	
	if $HealSound:
		$HealSound.play()

func play_pickup_sound() -> void:
	if $PickupSound:
		$PickupSound.play()

# Обновление UI (если есть)
func update_health_display(current: int, max: int) -> void:
	if health_label:
		health_label.text = "HP: %d/%d" % [current, max]

func update_ammo_display(current: int) -> void:
	if ammo_label:
		ammo_label.text = "Ammo: %d" % current

# Визуальная анимация уничтожения
func destroy() -> void:
	if not is_alive:
		return
		
	is_alive = false
	
	var tween = create_tween()
	
	# Анимация взрыва/уничтожения
	tween.tween_property(self, "scale", Vector3(2.0, 2.0, 2.0), 0.3)\
			.set_ease(Tween.EASE_OUT)\
			.set_trans(Tween.TRANS_BACK)
	
	tween.tween_property(self, "scale", Vector3.ONE, 0.3)\
			.set_ease(Tween.EASE_IN)\
			.set_trans(Tween.TRANS_ELASTIC)
	
	await tween.finished
	fighter_model.visible = false
	
	# Воспроизводим звук взрыва
	if $ExplosionSound:
		$ExplosionSound.play()

func respawn() -> void:
	is_alive = true
	fighter_model.visible = true
	scale = Vector3.ONE
	
	# Визуальный эффект респавна
	var tween = create_tween()
	tween.tween_property(fighter_model, "modulate", Color.YELLOW, 0.2)
	tween.tween_property(fighter_model, "modulate", Color.WHITE, 0.2)

func _on_body_entered(body: Node) -> void:
	# Передаем коллизию в контроллер
	controller.handle_collision(body)
