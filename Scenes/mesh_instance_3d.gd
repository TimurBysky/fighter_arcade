extends Node3D



func _ready():
	var animation = get_node("AnimationPlayer") as AnimationPlayer
	animation.play("Full")
