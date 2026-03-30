extends Node3D

@onready var enemy = preload("res://Scenes/enemy.tscn")
@onready var ammo = preload("res://Scenes/ammo.tscn")
@onready var health = preload("res://Scenes/health.tscn")
@onready var spawn_timer = $Spawn_timer
@onready var level_model:LevelData = load("res://Scripts/levels/level_data.tres")
@onready var level_controller = get_node("/root/LevelController")
@onready var player: Node = $Fighter
@onready var UI: CanvasLayer = $CanvasLayer
@onready var player_controller = get_node("/root/PlayerController")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer.timeout.connect(create_object)
	spawn_timer.start(level_model.spawn_interval)
	level_controller.setup(self)
	if(player):
		level_controller.init_player(player_controller)
	var restart_button: Button = $CanvasLayer/MarginContainer/VBoxContainer/Restart_button
	restart_button.pressed.connect(_restart)

func create_object() -> void:
	var object_list = level_model.get_objects()
	
	var object_for_spawn = level_controller.get_random_object_with_chance(level_model.get_objects())
	var instance = load(object_list[object_for_spawn]["scene"]).instantiate()
	instance.global_position = level_controller.get_random_position(level_model.get_spawn_positions())
	add_child(instance)
	print(object_for_spawn)
	
func show_defeat_screen():
	UI.visible = true

func _restart():
	player_controller.reset()
	get_tree().reload_current_scene()
