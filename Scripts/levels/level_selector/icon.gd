# views/level/level_icon.gd
extends Control  # или Node2D
class_name LevelIcon

@onready var picture: TextureRect = $VBoxContainer/Picture
@onready var level_name: Label = $VBoxContainer/Level_name
@onready var start_button: Button = $VBoxContainer/Start_button
@onready var star_1: TextureRect = $VBoxContainer/Stars_container/star1
@onready var star_2: TextureRect = $VBoxContainer/Stars_container/star2
@onready var star_3: TextureRect = $VBoxContainer/Stars_container/star3

@onready var controller = get_node("/root/LevelController")

var level_data: LevelData
var level_progress: Dictionary = {}  # прогресс из PlayerSaveData


func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)


func setup(level: LevelData, progress: Dictionary, level_controller: LevelController) -> void:
	level_data = level
	level_progress = progress
	controller = level_controller
	update_display()#поэтому ждём, т.к. элементы могли не успеть инициализироваться
	print_debug("Иконка готова!")

func update_display() -> void:
	var _level_name = level_data.get_level_name()
	
	# Название уровня
	level_name.text = _level_name
	# Проверяем, открыт ли уровень
	var is_unlocked = not level_progress.is_empty()
	
	if is_unlocked:
		start_button.disabled = false
		# Обновляем звезды
		var stars_earned = level_progress.get("stars_count", 0)
		print_debug("Звёзд: ",stars_earned)
		update_stars(stars_earned)
	else:
		start_button.disabled = true
		# Показываем замок или затемняем
		modulate = Color(0.5, 0.5, 0.5)

func update_stars(stars_earned: int) -> void:
	var stars = [star_1, star_2, star_3]
	
	for i in range(stars.size()):
		if i < stars_earned:
			stars[i].modulate = Color.YELLOW  # Золотая звезда
		else:
			stars[i].modulate = Color.GRAY   # Серая звезда

func _on_start_pressed() -> void:
	print_debug("Кнопка нажата, информация об уровне: ", level_data)
	controller.start_level(level_data)
