extends Node2D

@export var target: CharacterBody2D
@export var SPEED: float = 20
var attack: Attack

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	print(is_instance_valid(target))
	if is_instance_valid(target):
		global_position = global_position.move_toward(target.global_position, SPEED * delta)
	else:
		delete_self()

func _on_hitbox_component_area_entered(area):
	if area is HurtboxComponent:
		area.take_attack(attack)
		delete_self()

func delete_self():
	queue_free()
