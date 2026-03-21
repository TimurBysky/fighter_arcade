extends Node3D
@onready var fighter = $CharacterBody3D
@onready var tracer =  preload("res://tracer.tscn")
@onready var area3D = $CharacterBody3D/Area3D

@export var speed = 5.0
@export var fire_rate = 0.1  # Секунд между выстрелами
var can_shoot = true

func _ready() -> void:
	fighter.collision_layer = 1
	area3D.body_entered.connect(on_body_entered)
	area3D.collision_mask = 4

func _process(delta: float) -> void:
	var input_direction = Input.get_axis("ui_right", "ui_left")
	
	var movement = Vector3.ZERO
	movement.z = input_direction * speed
		
	fighter.velocity = movement
		
	fighter.move_and_slide()
	
	var pos = fighter.global_position
	pos.z = clamp(pos.z, -11.0, 11.0)
	fighter.global_position = pos
	
	if Input.is_key_pressed(KEY_SPACE) and can_shoot:
			shoot()

func shoot():
	can_shoot = false
	
	var instance = tracer.instantiate()
	add_child(instance)
	instance.global_position = fighter.global_position + Vector3(-1,0,0)
	# Автоматическое удаление трассера
	
	# Задержка перед следующим выстрелом
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
	
func on_body_entered(body):
	if(body.name == "Ammo"):
		print("Получил патроны!")
	if(body.name == "Health"):
		print("Получил рем-комплект!")
	print("Касание!")
