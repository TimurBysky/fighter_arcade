extends Node3D
@onready var fighter = $CharacterBody3D
@export var speed = 5.0

func _ready() -> void:
	pass



func _process(delta: float) -> void:
	var input_direction = Input.get_axis("ui_right", "ui_left")
	
	var movement = Vector3.ZERO
	movement.z = input_direction * speed
	
	fighter.velocity = movement
	
	fighter.move_and_slide()
