extends Sprite3D
@onready var fighter_model = $"../CharacterBody3D/Fighter_Model"
@onready var fighter = $".."
@export var speed = 5.0
@export var offest = Vector3(0.5, -1.72, 2.4)
@onready var label = $Label3D 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target_pos = fighter_model.global_position + offest
	global_position = global_position.lerp(target_pos, speed * delta)
	label.text = "Здоровье: {health}\nПатроны: {ammo}".format({
		"health": fighter.health,
		"ammo": fighter.ammo
	})
