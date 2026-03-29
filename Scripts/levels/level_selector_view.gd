# views/level/level_selector_view.gd
extends CanvasLayer
class_name LevelSelectorView

@onready var levels_grid: GridContainer = $MarginContainer/GridContainer
@onready var total_stars_label: Label = $MarginContainer2/VBoxContainer2/total_stars_label
#@onready var progress_label: Label = $TopPanel/ProgressLabel

var controller: LevelController
var level_icon_scene: PackedScene = preload("res://Scripts/levels/level_icon.tscn")

func _ready() -> void:
	controller = get_node("/root/LevelController")
	controller.load_all_levels()  # Загружаем все уровни
	generate_level_icons()
	update_statistics()

func generate_level_icons() -> void:
	# Очищаем контейнер
	for child in levels_grid.get_children():
		child.queue_free()
	
	# Создаем иконку для каждого уровня
	for level in controller.all_levels:
		var progress = controller.get_progress_for_level(level.level_id)
		var icon = level_icon_scene.instantiate()
		icon.setup(level, progress, controller)
		levels_grid.add_child(icon)

func update_statistics() -> void:
	var total_stars = 0
	var completed = 0
	
	for level in controller.all_levels:
		var progress = controller.get_progress_for_level(level.level_id)
		total_stars += progress.stars_earned
		if progress.times_completed > 0:
			completed += 1
	
	total_stars_label.text = "★ %d" % total_stars
	#progress_label.text = "Пройдено: %d/%d" % [completed, controller.all_levels.size()]

# Обновление после завершения уровня (можно вызвать при возврате на карту)
func refresh() -> void:
	generate_level_icons()
	update_statistics()
