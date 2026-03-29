extends Node
class_name MainMenuView

@onready var start_button: Button = $Main_Menu/MarginContainer/VBoxContainer/Start_button
@onready var exit_button: Button = $Main_Menu/MarginContainer/VBoxContainer/Exit_button
@onready var back_button: Button = $Level_selector/MarginContainer2/VBoxContainer/Back_button
@onready var score_label: Label = $Main_Menu/MarginContainer/VBoxContainer2/Score
@onready var enemy_kill_count_label: Label = $Main_Menu/MarginContainer/VBoxContainer2/Enemy_kill_count
@onready var completed_levels: Label = $Main_Menu/MarginContainer/VBoxContainer2/Completed_levels
@onready var main_menu: CanvasLayer = $Main_Menu
@onready var level_selector: CanvasLayer = $Level_selector
@onready var controller = get_node("/root/MainMenuController")
@onready var player_stats_data: PlayerStatsData = load(\
"res://Scripts/main_menu/player_stats_data.tres")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	controller.setup(self, player_stats_data)
	
	start_button.pressed.connect(_start)
	exit_button.pressed.connect(_exit)
	back_button.pressed.connect(_go_to_the_main_menu)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_kill_count_data(enemy_kill_count: int) -> void:
	enemy_kill_count_label.text = ("ENEMY KILL COUNT: " + str(enemy_kill_count))

func update_score_data(total_score: int) -> void:
	score_label.text = ("TOTAL SCORE: " + str(total_score))

func update_completed_levels(new_completed_levels):
	completed_levels.text = ("COMPLETED LEVELS: " + str(new_completed_levels))

func _start() -> void:
	main_menu.visible = false
	level_selector.visible = true
	#contorller.start_level()

func _exit() -> void:
	controller.close_game()
	
func _go_to_the_main_menu() -> void:
	main_menu.visible = true
	level_selector.visible = false
