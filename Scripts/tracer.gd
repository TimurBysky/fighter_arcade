extends CharacterBody3D
class_name Tracer
@export var tracer_lifetime = 2.0

@export var speed = 10.0
@export var direction: Vector3 = Vector3(-1, 0, 0) 
var damage: float = 1.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("bullets")
	collision_mask = 0
	await get_tree().create_timer(tracer_lifetime).timeout
	queue_free()
	 
func shoot_by_(owner: String = "player"):
	match(owner):
		"player":
			collision_layer = 4
		"enemy":
			collision_layer = 16
			speed = 5.0
	
func _process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()

	move_and_slide()

func destroy():
	queue_free()
