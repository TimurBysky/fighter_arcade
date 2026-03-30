extends Node
class_name MainMenuView

@onready var start_button: Button = $Main_screne/MarginContainer/VBoxContainer/Start_button
@onready var exit_button: Button = $Main_screne/MarginContainer/VBoxContainer/Exit_button
@onready var score_label: Label = $Main_screne/MarginContainer/VBoxContainer2/Score
@onready var enemy_kill_count_label: Label = $Main_screne/MarginContainer/VBoxContainer2/Enemy_kill_count
@onready var level_selector_screne: LevelSelectorView = $Level_selector_screne
@onready var main_screne: CanvasLayer = $Main_screne


@onready var contorller = get_node("/root/MainMenuController")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.pressed.connect(_start)
	exit_button.pressed.connect(_exit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_kill_count_data(enemy_kill_count: int) -> void:
	enemy_kill_count_label.text = ("ENEMY KILL COUNT: " + str(enemy_kill_count))

func update_score_data(total_score: int) -> void:
	score_label.text = ("TOTAL SCORE: " + str(total_score))

func _start() -> void:
	level_selector_screne.visible = true
	main_screne.visible = false

func show_main_menu():
	main_screne.visible = true

func _exit() -> void:
	contorller.close_game()
