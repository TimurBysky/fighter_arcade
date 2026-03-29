# views/level/level_icon.tscn (создайте в редакторе)
# Структура: Button -> { TextureRect, Label, StarsContainer }

# views/level/level_icon.gd
extends Node2D
class_name LevelIcon

@onready var preview_texture: TextureRect = $MarginContainer/VBoxContainer/Picture
@export var level_name_button: Button
#@onready var level_label: Label = $LevelLabel
#@onready var stars_container: HBoxContainer = $StarsContainer
#@onready var lock_icon: TextureRect = $LockIcon




var level_data: LevelData
var level_progress: LevelProgressData
var controller: LevelController

func setup(level: LevelData, progress: LevelProgressData, level_controller: LevelController) -> void:
	level_data = level
	level_progress = progress
	controller = level_controller
	
	update_display()
	level_name_button.pressed.connect(_on_pressed)

func update_display() -> void:
	level_name_button.text = level_data.level_name
	
	if level_progress.is_unlocked:
		#lock_icon.visible = false
		level_name_button.disabled = false
		update_stars()
	else:
		#lock_icon.visible = true
		#stars_container.visible = false
		level_name_button.disabled = true

func update_stars() -> void:
	# Очищаем старые звезды
	#for child in stars_container.get_children():
		#child.queue_free()
	#
	## Добавляем звезды (0-3)
	#for i in range(3):
		#var star = TextureRect.new()
		#star.texture = preload("res://assets/ui/star_empty.png")  # путь к текстуре пустой звезды
		#star.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		#
		#if i < level_progress.stars_earned:
			#star.texture = preload("res://assets/ui/star_filled.png")  # путь к текстуре заполненной звезды
		#
		#stars_container.add_child(star)
	pass
	
func _on_pressed() -> void:
	controller.select_level(level_data.level_id)
	controller.start_current_level()
