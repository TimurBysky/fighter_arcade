extends Resource
class_name PlayerData

@export var speed: float = 5.0
@export var fire_rate: float = 0.1  # Секунд между выстрелами
@export var max_health: int = 3
@export var current_health: int = 3
@export var max_ammo: int = 100
@export var current_ammo: int = 20

signal health_changed(new_healt: int, max_health: int)
signal ammo_changed(new_ammo: int)
signal player_died()
signal player_respawn()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health
	current_ammo = max_ammo

func take_damage(amount: int = 1) -> void:
	if current_health <= 0:
		return
		
	current_health -= amount
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0:
		die()
		
func heal(amount: int = 1)  -> void:
	
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
	
func die() -> void:
	player_died.emit()
	
func respawn() -> void:
	current_health = max_health
	current_ammo = max_ammo
	player_respawn.emit()
	ammo_changed.emit(current_ammo)
	health_changed.emit(current_health, max_health)

func reset() -> void:
	current_health = max_health
	current_ammo = max_ammo
	player_respawn.emit()
	ammo_changed.emit(current_ammo)
	health_changed.emit(current_health, max_health)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
