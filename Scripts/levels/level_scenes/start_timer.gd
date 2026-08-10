extends Label

signal game_start
var values = ["3", "2", "1", "Go!"]
var index = 0

func _ready():
	modulate.a = 0.0
	play_next()
	if index >= values.size():
		game_start.emit()

func play_next():
	if index >= values.size() - 1:
		game_start.emit()
		
	if index >= values.size():
		return
	
	text = values[index]
	modulate.a = 0.0
	scale = Vector2(0.5, 0.5)
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "modulate:a", 1.0, 0.3)
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.3)
	tween.set_parallel(false)
	tween.tween_property(self, "modulate:a", 0.0, 0.5).set_delay(0.2)
	
	index += 1
	tween.tween_callback(play_next).set_delay(0.3)
