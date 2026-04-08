# Scripts/levels/level_scenes/level_1.gd
extends Node3D

@onready var spawn_timer = $Spawn_timer
@onready var level_controller = get_node("/root/LevelController")
@onready var player: Node = $Fighter
@onready var UI: CanvasLayer = $CanvasLayer
@onready var player_controller = get_node("/root/PlayerController")
@onready var restart_button: Button = $CanvasLayer/MarginContainer/VBoxContainer/Restart_button
@onready var main_menu_button: Button = $CanvasLayer/MarginContainer/VBoxContainer/Main_menu_button


var level_model: LevelData

func _ready() -> void:
	# Получаем данные уровня из контроллера
	level_model = level_controller.get_current_level_data()
	
	if not level_model:
		print("Ошибка: данные уровня не загружены!")
		return
	
	level_controller.setup(self)
	if player:
		level_controller.init_player(player_controller)
	
	# Кнопка рестарта
	if main_menu_button:
		main_menu_button.pressed.connect(_exit_to_main_menu)
	if restart_button:
		restart_button.pressed.connect(_restart)

func create_object() -> void:
	if not level_model:
		return
	
	var object_list = level_model.get_objects()
	var object_type = level_controller.get_random_object_with_chance(object_list)
	
	if not object_list.has(object_type):
		return
	
	var scene_path = object_list[object_type]["scene"]
	var instance = load(scene_path).instantiate()
	instance.global_position = level_controller.get_random_position(level_model.get_spawn_positions())
	add_child(instance)
	if instance.is_in_group("Enemy"):
		level_controller.register_enemy(instance.controller)
		
func show_defeat_screen() -> void:
	UI.visible = true

func _exit_to_main_menu():
	level_controller.exit_to_mani_menu()

func _restart() -> void:
	if player_controller and player_controller.has_method("reset"):
		player_controller.reset()
	get_tree().reload_current_scene()
