extends Node3D

@export var speed: float = 3.0

func _process(delta: float) -> void:
	var offest = Vector3(delta * speed, 0, 0)
	position += offest
