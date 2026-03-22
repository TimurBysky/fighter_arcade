extends Node3D
@onready var fighter = $CharacterBody3D
@onready var fighter_model = $CharacterBody3D/Fighter_Model
@onready var tracer =  preload("res://tracer.tscn")
@onready var area3D = $CharacterBody3D/Area3D

@export var speed = 5.0
@export var fire_rate = 0.1  # Секунд между выстрелами
@export var health = 3
@export var ammo = 20
var is_alive = true
var can_shoot = true

func _ready() -> void:
	area3D.body_entered.connect(on_body_entered)
	area3D.collision_mask = 3|4

func _process(delta: float) -> void:
	if(is_alive):
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
	if(ammo > 0):
		can_shoot = false

		var instance = tracer.instantiate()
		instance.global_position = fighter.global_position + Vector3(-1,0,0)
		add_child(instance)
		ammo -= 1
		# Автоматическое удаление трассера

		# Задержка перед следующим выстрелом
		await get_tree().create_timer(fire_rate).timeout
		can_shoot = true

func on_body_entered(body):
	if(is_alive):
		if(body.is_in_group("Ammo")):
			print("Получил патроны!")
			ammo += 30
		if(body.is_in_group ("Health")):
			print("Получил рем-комплект!")
			if(health < 3):
				health += 1
		if(body.is_in_group ("Enemy")):
			print("Враг!")
			health -= 1
			if(health <= 0 ):
				destroy()
		if(body.has_method("destroy")):
			body.destroy()
		print("Касание!", body.name)
	
func destroy():
	if(is_alive):
		is_alive = false

		var tween = create_tween()

		# Увеличиваемся
		tween.tween_property(self, "scale", Vector3(2.0, 2.0, 2.0), 0.3)\
				.set_ease(Tween.EASE_OUT)\
				.set_trans(Tween.TRANS_BACK)

		# Уменьшаемся до нормального размера
		tween.tween_property(self, "scale", Vector3.ONE, 0.3)\
				.set_ease(Tween.EASE_IN)\
				.set_trans(Tween.TRANS_ELASTIC)

		await tween.finished
		fighter_model.visible = false
