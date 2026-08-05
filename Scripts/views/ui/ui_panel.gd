extends Sprite3D
@onready var fighter_model = $"../CharacterBody3D/Fighter_Model"
@onready var fighter = $".."
@export var speed = 5.0
@export var offest = Vector3(0.5, -1.72, 2.4)
#@onready var label = $Label3D 

func move_to_player(model: CharacterBody3D, delta: float):
	var target_pos = model.global_position + offest
	global_position = global_position.lerp(target_pos, speed * delta)
	#label.text = "Здоровье: {health}\nПатроны: {ammo}".format({
		#"health": fighter.health,
		#"ammo": fighter.ammo
	#})
