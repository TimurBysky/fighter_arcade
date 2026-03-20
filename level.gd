extends Node3D

@onready var enemy = preload("res://enemy.tscn")
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
	
	var generate_position = randi_range(1,3)
	var spawn_position = Vector3(-27,0,0)
	
	match generate_position:
		1:
			spawn_position.z = -8.0
		2:
			spawn_position.z = 0.0
		3:
			spawn_position.z = 8.0
			
	var instance = enemy.instantiate()
	add_child(instance)
	instance.global_position = spawn_position
	
	create_enemy()
	
