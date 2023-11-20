extends Node2D

@export var target: CharacterBody2D
@export var SPEED_MAX: float = 500
var speed: float = 200
var velocity: Vector2
var acceleration: Vector2
var attack: Attack

# Called when the node enters the scene tree for the first time.
func _ready():
	acceleration.x = 700
	acceleration.y = 700
	get_target()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if is_instance_valid(target):
		# rotate acceleration towards enemy
		var acc_direciton = global_position.direction_to(target.global_position)
		acceleration = acc_direciton * acceleration.length()
#		global_position = global_position.move_toward(target.global_position, speed * delta)
#		look_at(target.global_position)
#		rotation += 90
		velocity.x += acceleration.x * delta
		velocity.y += acceleration.y * delta
		global_position.x += velocity.x * delta
		global_position.y += velocity.y * delta
	else:
		get_target()
#	if velocity.length() < SPEED_MAX:


func _on_hitbox_component_area_entered(area):
	if area is HurtboxComponent:
		area.take_attack(attack)
		delete_self()

func get_target():
	var enemies = get_tree().get_nodes_in_group("Enemies")
	if enemies.size() > 0:
		target = enemies[0]
		for enemy in enemies:
			if global_position.distance_to(enemy.global_position) < global_position.distance_to(target.global_position):
				target = enemy
	else:
		delete_self()

func delete_self():
	queue_free()

