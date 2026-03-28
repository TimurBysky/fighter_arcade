# models/player/player_data.gd
extends Resource
class_name PlayerData

# Экспортируем параметры для настройки в редакторе
@export var max_health: int = 3
@export var current_health: int = 3
@export var max_ammo: int = 99
@export var current_ammo: int = 20
@export var speed: float = 5.0
@export var fire_rate: float = 0.1
@export var have_shoot_bonus: bool = false
@export var standart_damage_multypler: float = 1.0
var damage_multypler: float
# Сигналы для оповещения о изменениях (чистая логика!)
signal health_changed(new_health: int, max_health: int)
signal ammo_changed(new_ammo: int)
signal player_died()
signal player_respawned()

func _init():
	# Инициализация
	damage_multypler = standart_damage_multypler
	current_health = max_health
	current_ammo = 20

# Чистая логика без визуала!
func take_damage(amount: int = 1) -> void:
	if current_health <= 0:
		return
		
	current_health -= amount
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0:
		die()

func heal(amount: int = 1) -> void:
	if current_health >= max_health:
		return
		
	current_health = min(current_health + amount, max_health)
	health_changed.emit(current_health, max_health)

func add_ammo(amount: int = 30) -> void:
	current_ammo = min(current_ammo + amount, max_ammo)
	ammo_changed.emit(current_ammo)

func can_shoot() -> bool:
	return current_ammo > 0

func consume_ammo() -> void:
	if can_shoot():
		current_ammo -= 1
		ammo_changed.emit(current_ammo)

func reset_damage_multypler() -> void:
	damage_multypler = standart_damage_multypler

func die() -> void:
	player_died.emit()

func respawn() -> void:
	damage_multypler = standart_damage_multypler
	current_health = max_health
	current_ammo = 20
	player_respawned.emit()
	health_changed.emit(current_health, max_health)
	ammo_changed.emit(current_ammo)

# Сброс состояния (для переиспользования)
func reset() -> void:
	damage_multypler = standart_damage_multypler
	current_health = max_health
	current_ammo = 20
	health_changed.emit(current_health, max_health)
	ammo_changed.emit(current_ammo)
