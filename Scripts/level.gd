extends Node3D

@onready var enemy = preload("res://Scenes/enemy.tscn")
@onready var ammo = preload("res://Scenes/ammo.tscn")
@onready var health = preload("res://Scenes/health.tscn")
@onready var spawn_timer = $Spawn_timer
#var ObjectList: Node
#var GeneratingObjects: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer.timeout.connect(create_object)
	



func create_object() -> void:
	var level_model:LevelData = load("res://Scripts/levels/level_data.tres")
	var level_controller = get_node("/root/LevelController")
	var object_list = level_model.get_objects()
	
	var object_for_spawn = level_controller.get_random_object_with_chance(level_model.get_objects())
	var instance = load(object_list[object_for_spawn]["scene"]).instantiate()
	instance.global_position = level_controller.get_random_position(level_model.get_spawn_positions())
	add_child(instance)
	print(object_for_spawn)
	
