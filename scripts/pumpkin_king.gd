extends CharacterBody2D

@export var damage: float = 5
@export var knockback: float = 0
@export var health_max: float = 200
@export var movement_cooldown: float = 0.25
@export var movement_time: float = 0.25
@export var speed: float = 140
@export var rotate_amount: float = 0.0075
@export var experience_value: int = 20

var waiting: bool = true
var moving: bool = false
var movement_direction: Vector2
var rotate_direction: int = 0
var rotate_direction_increment: int = 1
var current_delta_count: float = 0
var attack: Attack

signal enemy_died(experience)

func _ready():
	attack = Attack.new()
	attack.damage = damage
	attack.knockback = knockback
	
	$HealthComponent.set_max_health(health_max, false)

func _physics_process(delta):
	if !$Target.is_valid():
		return
	if waiting:
		current_delta_count += delta
		if current_delta_count >= movement_cooldown:
			movement_direction = $Target.direction_to_target()
			current_delta_count = 0
			waiting = false
			moving = true
	if moving:
		current_delta_count += delta
		velocity = movement_direction * speed * delta
		move_and_collide(velocity)
		# TODO ROTATE 
		rotation += rotate_amount
		
		if current_delta_count >= movement_time:
			rotate_direction += rotate_direction_increment
			if rotate_direction == 1:
				rotate_direction_increment = -1
				rotate_amount *= -1
			elif rotate_direction == -1:
				rotate_direction_increment = 1
				rotate_amount *= -1
			current_delta_count = 0
			moving = false
			waiting = true


func get_offset_global_position() -> Vector2:
	return global_position

func set_target(new_target: Node2D):
	$Target.set_target(new_target)

func _on_hurtbox_component_attacked(attack):
	$HealthComponent.take_damage(attack)


func _on_hitbox_component_area_entered(area):
	if area is HurtboxComponent:
		area.take_attack(attack)


func _on_health_component_no_health(current_health):
	delete_self()

func delete_self():
	enemy_died.emit(experience_value)
	queue_free()
