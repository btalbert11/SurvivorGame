class_name Target
extends Node2D

@export var target: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_target(new_target: Node2D) -> bool:
	if is_instance_valid(new_target):
		target = new_target
		return true
	return false

func direction_to_target() -> Vector2:
	if is_instance_valid(target):
		return global_position.direction_to(target.global_position)
	return Vector2.ZERO

func is_valid() -> bool:
	return is_instance_valid(target)
