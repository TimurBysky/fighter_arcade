extends Node3D
@onready var tracer = $CharacterBody3D

@export var speed = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tracer.collision_layer = 2 
	tracer.collision_mask = 3  
	await get_tree().create_timer(1.0).timeout
	queue_free()
	 
func _process(delta: float) -> void:
	var movement = Vector3.ZERO
	movement.x = -speed
	tracer.velocity = movement

	tracer.move_and_slide()
