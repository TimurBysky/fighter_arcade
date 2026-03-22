extends CharacterBody3D
@onready var area3D = $Area3D
@export var speed = 5.0
@export var health = 5

var is_alive = true


func _ready() -> void:
	area3D.body_entered.connect(collision)
	collision_mask = 0
	collision_layer = 2
	area3D.collision_mask = 2
	 
func _process(delta: float) -> void:
	var movement = Vector3.ZERO
	movement.x = speed
	velocity = movement

	move_and_slide()
	
func collision(body):
	print("Тело: ", body.name)
	print("Группы тела: ", body.get_groups())  # Посмотрим, есть ли "bullets"
	
	if body.is_in_group("bullets"):
		body.destroy()
		destroy()


func destroy():
	var tween = create_tween()

	# Увеличиваемся
	tween.tween_property(self, "scale", Vector3(2.0, 2.0, 2.0), 0.3)\
			.set_ease(Tween.EASE_OUT)\
			.set_trans(Tween.TRANS_BACK)

	# Уменьшаемся до нормального размера
	tween.tween_property(self, "scale", Vector3.ONE, 0.3)\
			.set_ease(Tween.EASE_IN)\
			.set_trans(Tween.TRANS_ELASTIC)
	
	await tween.finished
	queue_free()
