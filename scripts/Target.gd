class_name Target
extends Node2D

@export var target: Node2D

func set_target(new_target: Node2D) -> bool:
	if is_instance_valid(new_target):
		target = new_target
		return true
	return false

func direction_to_target() -> Vector2:
	if is_valid():
		return global_position.direction_to(target.global_position)
	return Vector2.ZERO

func distance_to_target() -> float:
	if is_valid():
		return global_position.distance_to(target.global_position)
	return -1

func is_valid() -> bool:
	return is_instance_valid(target)
