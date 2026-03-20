extends CharacterBody3D
@export var tracer_lifetime = 2.0

@export var speed = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("bullets")
	collision_layer = 2
	collision_mask = 0
	await get_tree().create_timer(tracer_lifetime).timeout
	queue_free()
	 
func _process(delta: float) -> void:
	var movement = Vector3.ZERO
	movement.x = -speed
	velocity = movement

	move_and_slide()

func destroy():
	queue_free()
