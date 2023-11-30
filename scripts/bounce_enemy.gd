extends CharacterBody2D

@export var damage: float = 4
@export var knockback: float = 1
@export var movement_cooldown: float = 1
@export var max_movement_distance: float = 400
@export var jump_speed: float = 2
@export var jump_height: float = 150
@export var jump_hold_time: float = 0.3
@export var falling_speed: float = 500
@export var target: CharacterBody2D
var movement_target: Vector2
var waiting: bool = true
var jumping: bool = false
var jump_hold: bool = false
var falling: bool = false
var current_wait: float = 0
var percent_moved: float = 0
var jump_starting_point: Vector2


var attack: Attack

func _ready():
	attack = Attack.new()
	attack.damage = damage
	attack.knockback = knockback
	
	var rng = RandomNumberGenerator.new()
	jump_speed *= rng.randf_range(0.99, 1.01)
	jump_hold_time *= rng.randf_range(0.99, 1.01)
	movement_cooldown *= rng.randf_range(0.99, 1.01)
	
	$HitboxComponent.disable()

func _physics_process(delta):
	if waiting:
		current_wait += delta
		# Jump toward player
		if current_wait >= movement_cooldown:
			movement_target = get_movement_target()
			jump_starting_point = global_position
			current_wait = 0
			$HitboxComponent.disable()
			$PhysicsCollision.set_deferred("disabled", true)
			$Sprite2D.z_index = 10
			waiting = false
			jumping = true
	if jumping:
		percent_moved += jump_speed * delta
		if percent_moved >= 1:
			percent_moved = 1
		var new_pos = (jump_starting_point.distance_to(movement_target) * percent_moved) * (movement_target - jump_starting_point).normalized()
		new_pos = jump_starting_point + new_pos
		if jump_starting_point.distance_to(movement_target) >= 0.01:
			global_position = new_pos
		$Sprite2D.position.y = -(percent_moved * jump_height)
		$HurtboxComponent.position.y = -(percent_moved * jump_height)
		if percent_moved >= 1:
			percent_moved = 0
			jumping = false
			jump_hold = true
	if jump_hold:
		current_wait += delta
		if current_wait >= jump_hold_time:
			current_wait = 0
			jump_hold = false
			falling = true
	if falling:
		$Sprite2D.position.y += falling_speed * delta
		$HurtboxComponent.position.y += falling_speed * delta
		if $Sprite2D.position.y >= 0:
			$Sprite2D.position.y = 0
			$HitboxComponent.enable()
			$PhysicsCollision.set_deferred("disabled", false)
			$Sprite2D.z_index = 0
			falling = false
			waiting = true

func get_offset_global_position() -> Vector2:
	var offset = $HurtboxComponent.position.y
	var pos = global_position
	pos.y += offset
	return pos

func get_movement_target() -> Vector2:
	var new_target = target.global_position
	# Player is farther away than movement range
	if global_position.distance_to(new_target) > max_movement_distance:
		new_target = (new_target - global_position).normalized() * max_movement_distance
		new_target = global_position + new_target
	
	var rng = RandomNumberGenerator.new()
	new_target.x *= rng.randf_range(0.99, 1.01)
	new_target.y *= rng.randf_range(0.99, 1.01)
	return new_target

func set_target(new_target):
	if is_instance_valid(new_target):
		target = new_target

func _on_hurtbox_component_attacked(attack):
	$HealthComponent.take_damage(attack)

func _on_hitbox_component_area_entered(area):
	if area is HurtboxComponent:
		attack.origin = global_position
		area.take_attack(attack)

func _on_health_component_no_health(current_health):
	delete_self()

func delete_self():
	queue_free()
