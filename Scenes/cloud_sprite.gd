extends Node3D

@onready var cloud_end:Area3D = $"../Area3D"

var clouds: Array = []

func _ready() -> void:
	add_to_group("Clouds")
	cloud_end.area_entered.connect(_on_area_3d_area_entered)
	get_visible()

func get_visible() -> void:
	for cloud in get_children():
		if cloud is Sprite3D:
			appear_animation(cloud)


func appear_animation(cloud:Sprite3D, duration: float = 5.0) -> void:
	cloud.modulate.a = 0.0
	
	var tween := create_tween()
	tween.tween_property(cloud, "modulate:a", 1.0, duration)

	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_area_3d_area_entered(level_border: Area3D):
	if level_border.is_in_group("level_border"):
		for cloud in get_children():
			if cloud is Sprite3D:
				fade_animation(cloud)

func fade_animation(cloud:Sprite3D, duration: float = 15.0)-> void:
	
	var tween := create_tween()
	tween.tween_property(cloud, "modulate:a", 0.0, duration)

	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished
	queue_free()
	
