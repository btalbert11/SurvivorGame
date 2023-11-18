extends CharacterBody2D


@export var SPEED: float = 100.0
@export var target: CharacterBody2D
@export var damage: float = 2
var attack: Attack

signal enemy_died

func _ready():
	attack = Attack.new()
	attack.damage = damage
	attack.knockback = 0

func _physics_process(delta):
	if is_instance_valid(target):
		var direction_to_player = global_position.direction_to(target.global_position)
		velocity = direction_to_player * SPEED * delta
	else:
		velocity = Vector2.ZERO
	move_and_collide(velocity)

func attack_targert() -> Attack:
	return attack

func _on_hitbox_area_entered(area):
	if area is HurtboxComponent:
		area.take_attack(attack)


func _on_hurtbox_component_attacked(attack):
	$HealthComponent.take_damage(attack)


func _on_health_component_no_health(current_health):
	delete_self()

func delete_self():
	enemy_died.emit()
	queue_free()
