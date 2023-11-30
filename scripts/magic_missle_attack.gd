extends Node2D

@export var target: CharacterBody2D
@export var SPEED_MAX: float = 500
@export var snap_distance: int = 35
@export var acceleration_value: float = 700
var speed: float = 200
var velocity: Vector2
var acceleration: Vector2
var attack: Attack

# Called when the node enters the scene tree for the first time.
func _ready():
	acceleration.x = acceleration_value
	acceleration.y = acceleration_value
	get_target()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if is_instance_valid(target):
		# snap to target to prevent orbiting
		if global_position.distance_to(target.get_offset_global_position()) < snap_distance:
			var dir_to = global_position.direction_to(target.get_offset_global_position())
			velocity = dir_to * velocity.length()
		# rotate acceleration towards enemy
		var acc_direciton = global_position.direction_to(target.get_offset_global_position())
		acceleration = acc_direciton * acceleration.length()
	else:
		get_target()
	# Update velocty and position
	velocity.x += acceleration.x * delta
	velocity.y += acceleration.y * delta
	global_position.x += velocity.x * delta
	global_position.y += velocity.y * delta
	
	# check if larger than max speed, if so reduce vector
	if velocity.length() > SPEED_MAX:
		var len = velocity.length()
		velocity = velocity * (1 - ((len - SPEED_MAX)/len))
	
	# POINT TOWARDS VELOCITY VECTOR. Magic Math
	rotation = velocity.angle() + PI/2 + PI/4 - PI/8


func _on_hitbox_component_area_entered(area):
	if area is HurtboxComponent:
		area.take_attack(attack)
		delete_self()

func get_target() -> bool:
	var enemies = get_tree().get_nodes_in_group("Enemies")
	if enemies.size() > 0:
		target = enemies[0]
		for enemy in enemies:
			if global_position.distance_to(enemy.get_offset_global_position()) < global_position.distance_to(target.get_offset_global_position()):
				target = enemy
		return true

	else:
		return false

func delete_self():
	queue_free()



func _on_visible_on_screen_notifier_2d_screen_exited():
	delete_self()
