extends Camera3D
@onready var fighter = $"../CharacterBody3D/Fighter_Model"
@export var speed = 3.0
@export var offest = Vector3(2, 2,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target_pos = fighter.global_position + offest
	global_position = global_position.lerp(target_pos, speed * delta)
