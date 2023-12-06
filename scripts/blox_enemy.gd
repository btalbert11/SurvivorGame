extends CharacterBody2D


@export var SPEED: float = 100.0
@export var damage: float = 2
@export var knockback: float = 0
@export var experience_value: int = 2
var attack: Attack

signal enemy_died(experience)

func _ready():
	attack = Attack.new()
	attack.damage = damage
	attack.knockback = knockback

func _physics_process(delta):
	if $Target.is_valid():
		velocity = $Target.direction_to_target() * SPEED * delta
	else:
		velocity = Vector2.ZERO
	move_and_collide(velocity)

func get_offset_global_position() -> Vector2:
	return global_position

func set_target(target: Node2D):
	$Target.set_target(target)

func _on_hitbox_area_entered(area):
	if area is HurtboxComponent:
		attack.origin = global_position
		area.take_attack(attack)

func _on_hurtbox_component_attacked(attack):
	$HealthComponent.take_damage(attack)

func _on_health_component_no_health(current_health):
	delete_self()

func delete_self():
	enemy_died.emit(experience_value)
	queue_free()
