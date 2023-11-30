extends Node2D
@export var trail_point: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	var new_point = trail_point.instantiate()
	new_point.global_position = global_position
	get_tree().get_root().get_child(0).add_child(new_point)
