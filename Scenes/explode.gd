extends AnimatedSprite3D

var effects = ["Boom", "Crush", "KABOOM"]

func _ready()->void:
	play(effects.pick_random())

	var tween = create_tween()
	tween.set_parallel(true)
	
	# Расширение
	tween.tween_property(self, "scale", Vector3(3.0, 3.0, 3.0), 0.7)
	
	# Затухание
	tween.tween_property(self, "modulate:a", 0.0, 0.5).set_delay(0.4)
	
	# Удаление после завершения
	tween.chain().tween_callback(queue_free)
