extends Node

var model: EnemyData
var view: Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var movement = Vector3.ZERO
	movement.x = model.speed


func setup(enemy_model: EnemyData, enemy_view: Node):
	model = enemy_model
	view = enemy_view
	
