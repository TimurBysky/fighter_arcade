extends Node3D



func _ready():
	var animation = get_node("AnimationPlayer") as AnimationPlayer
	if animation.has_animation("Full"):
		animation.play("Full")
	else:
		print_debug("Не найдена анимация!")
	
		
	
