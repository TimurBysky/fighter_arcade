# factories/enemy_factory.gd (Autoload или отдельный скрипт)
extends Node

var enemy_template: EnemyData

func _ready() -> void:
	# Загружаем шаблон один раз
	enemy_template = load("res://Scripts/models/enemy/enemy_data.tres")

func create_enemy(model: EnemyData = enemy_template) -> EnemyData:
	# Создаем новый экземпляр на основе шаблона
	var new_enemy = EnemyData.new()
	new_enemy.max_health = model.max_health
	new_enemy.speed = model.speed
	new_enemy.fire_rate = model.fire_rate
	new_enemy.spread_fire = model.spread_fire
	new_enemy.score = model.score
	new_enemy.current_health = new_enemy.max_health  # Сброс здоровья
	
	return new_enemy
