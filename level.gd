extends Node3D

@onready var enemy = preload("res://enemy.tscn")
@onready var ammo = preload("res://ammo.tscn")
@onready var health = preload("res://health.tscn")
@onready var spawn_timer = $Spawn_timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_enemy()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func create_enemy() -> void:
	
	spawn_timer.start(randf_range(0.5, 1.5))
	await  spawn_timer.timeout
	
	var generate_object_for_spawn = randi_range(1,10)
	var object_for_spawn: PackedScene
	
	var generate_position = randi_range(1,3)
	var spawn_position = Vector3(-27,0,0)
	
	match  generate_object_for_spawn:
		1,2,3,4,5,6:
			object_for_spawn = enemy
		7,8:
			object_for_spawn = health
		9,10:
			object_for_spawn = ammo
	
	match generate_position:
		1:
			spawn_position.z = -8.0
		2:
			spawn_position.z = 0.0
		3:
			spawn_position.z = 8.0
			
	var instance = object_for_spawn.instantiate()
	instance.global_position = spawn_position
	add_child(instance)
	
	create_enemy()
	
