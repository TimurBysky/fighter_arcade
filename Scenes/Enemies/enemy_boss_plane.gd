extends CharacterBody3D

@export var amplitude: float = 5.0      # Насколько далеко влево/вправо
@export var speed: float = 2.0          # Скорость качания
var start_position: Vector3
var time: float = 0.0

func _ready():
	start_position = global_position

func _process(delta):
	time += delta * speed
	global_position.z = start_position.z + sin(time) * amplitude
