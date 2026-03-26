# factories/enemy_factory.gd (Autoload или отдельный скрипт)
extends Node

var enemy_template: EnemyData

func _ready() -> void:
	# Загружаем шаблон один раз
	enemy_template = load("res://Scripts/models/enemy/enemy_data.tres")

func create_enemy() -> EnemyData:
	# Создаем новый экземпляр на основе шаблона
	var new_enemy = EnemyData.new()
	new_enemy.max_health = enemy_template.max_health
	new_enemy.speed = enemy_template.speed
	new_enemy.current_health = new_enemy.max_health  # Сброс здоровья
	
	return new_enemy
