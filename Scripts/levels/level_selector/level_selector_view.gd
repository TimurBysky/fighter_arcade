# views/level/level_selector_view.gd
extends CanvasLayer
class_name LevelSelectorView

@onready var levels_container: GridContainer = $MarginContainer/ScrollContainer/GridContainer
@onready var total_stars_label: Label = $TopPanel/TotalStarsLabel
@onready var back_button: Button = $TopPanel/BackButton

@export var level_icon_scene: PackedScene

var controller: LevelController
var save_manager


func _ready() -> void:
	controller = get_node("/root/LevelController")
	save_manager = get_node("/root/SaveManager")
	
	controller.levels_loaded.connect(_on_levels_loaded)
	back_button.pressed.connect(_on_back_pressed)
	
	# Загружаем уровни, если еще не загружены
	if controller.get_all_levels().is_empty():
		controller.load_all_levels()
	else:
		_on_levels_loaded(controller.get_all_levels())

func _on_levels_loaded(levels: Array[LevelData]) -> void:
	generate_level_icons(levels)
	update_statistics()

func generate_level_icons(levels: Array[LevelData]) -> void:
	# Очищаем контейнер
	for child in levels_container.get_children():
		child.queue_free()
	
	# Создаем иконку для каждого уровня
	for level in levels:
		var level_info = level.get_level_info().values()[0]
		var level_id = level_info["level_id"]
		
		# Получаем прогресс уровня из сохранений
		var progress = save_manager.get_level_progress(level_id)
		
		var icon = level_icon_scene.instantiate()
		icon.setup(level, progress, controller)
		levels_container.add_child(icon)

func update_statistics() -> void:
	var total_stars = save_manager.get_total_stars()
	total_stars_label.text = "★ %d" % total_stars

func _on_back_pressed() -> void:
	visible = false
	# Вернуться в главное меню
	if get_parent().has_method("show_main_menu"):
		get_parent().show_main_menu()
