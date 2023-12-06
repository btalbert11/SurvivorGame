extends CharacterBody2D
@export var damage: float = 5
@export var knockback: float = 1
@export var health_max: float = 50
@export var speed: float = 40
@export var rotation_speed: float = 0.5
@export var experience_value: int = 10
var attack: Attack

signal enemy_died(experience)

func _ready():
	attack = Attack.new()
	attack.damage = damage
	attack.knockback = knockback
	
	$HealthComponent.set_max_health(health_max, false)
	
func _physics_process(delta):
	if $Target.is_valid():
		velocity = $Target.direction_to_target() * speed * delta
		rotation += rotation_speed * delta
	else:
		velocity = Vector2.ZERO
	move_and_collide(velocity)

func set_target(new_target: Node2D):
	$Target.set_target(new_target)

func _on_hurtbox_component_attacked(attack):
	$HealthComponent.take_damage(attack)
	if ($HealthComponent.get_current_health() / $HealthComponent.get_max_health()) <= 0.3:
		$AnimatedSprite2D.frame = 2
	elif ($HealthComponent.get_current_health() / $HealthComponent.get_max_health()) <= 0.6:
		$AnimatedSprite2D.frame = 1

func _on_hitbox_component_area_entered(area):
	if area is HurtboxComponent:
		area.take_attack(attack)

func get_offset_global_position() -> Vector2:
	return global_position

func _on_health_component_no_health(current_health):
	delete_self()

func delete_self():
	enemy_died.emit(experience_value)
	queue_free()
