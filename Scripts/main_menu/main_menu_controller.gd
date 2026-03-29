extends Node

var view: Node
var model: PlayerStatsData
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func setup(menu_view: Node, player_stats_data: PlayerStatsData) -> void:
	view = menu_view
	model = player_stats_data
	
	model.kill_count_changed.connect(_kill_count_changed)
	model.score_changed.connect(_score_changed)
	model.completed_levels_changed.connect(_completed_levels_changed)
	
	if(view.has_method("update_score_data")):
		view.update_score_data(model.total_score)
	if(view.has_method("update_kill_count_data")):
		view.update_kill_count_data(model.enemy_kill_count)
		print("kill_counts")
	if(view.has_method("update_completed_levels")):
		view.update_completed_levels(model.completed_levels)

func _kill_count_changed(enemy_kill_count: int):
	if(view.has_method("update_kill_count_data")):
		view.update_kill_count_data(enemy_kill_count)

func _score_changed(new_score: int):
	if(view.has_method("update_score_data")):
		view.update_score_data(new_score)

func _completed_levels_changed(new_completed_levels: int):
	if(view.has_method("update_completed_levels")):
		view.update_completed_levels(new_completed_levels)


func start_level(level_id: int = 0):
	get_tree().change_scene_to_file("res://Scripts/levels/scenes/level.tscn")

func close_game():
	get_tree().quit()
	
