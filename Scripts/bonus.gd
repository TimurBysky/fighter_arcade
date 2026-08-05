extends CharacterBody3D
@export var speed = 5.0
@export var bonus_damage_multiplyer = 2.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_layer = 8


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var movement = Vector3.ZERO
	movement.x = speed
	velocity = movement

	move_and_slide()

func destroy():
	var tween = create_tween()
	# Увеличиваемся
	tween.tween_property(self, "scale", Vector3(2.0, 2.0, 2.0), 0.15)\
			.set_ease(Tween.EASE_OUT)\
			.set_trans(Tween.TRANS_BACK)

	# Уменьшаемся до нормального размера
	tween.tween_property(self, "scale", Vector3.ONE, 0.15)\
			.set_ease(Tween.EASE_IN)\
			.set_trans(Tween.TRANS_ELASTIC)

	
	await tween.finished
	queue_free()
