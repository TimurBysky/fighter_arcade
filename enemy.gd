extends Node3D
@onready var enemy = $CharacterBody3D

@export var speed = 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy.collision_layer = 3  
	 
func _process(delta: float) -> void:
	var movement = Vector3.ZERO
	movement.x = speed
	enemy.velocity = movement

	enemy.move_and_slide()
