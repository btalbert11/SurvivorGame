extends CharacterBody2D

@export var start_speed: float = 1000
@export var acceleration: float = 50
@export var damage: float = 3
@export var knock_back: float = 20
@export var movement_cooldown: float = 1
var moving: bool = false
var attack: Attack
var move_timer: Timer

signal enemy_died

func _ready():
	attack = Attack.new()
	attack.damage = damage
	attack.knockback = knock_back
	move_timer = Timer.new()
	move_timer.wait_time = movement_cooldown
	move_timer.one_shot = true
	move_timer.autostart = false
	move_timer.timeout.connect(_on_move_timer_timeout)
	add_child(move_timer)
	move_timer.start()

func _process(delta):
	pass

func _physics_process(delta):
	if moving:
		velocity -= Vector2(acceleration, acceleration)
		if velocity.x <= 0 || velocity.y <= 0:
			velocity = Vector2.ZERO
			moving = false
			move_timer.start()
		move_and_collide(velocity * delta)
	

func start_moving():
	var vel_direction = $Target.direction_to_target()
	var rng = RandomNumberGenerator.new()
	velocity = Vector2(start_speed, start_speed) * vel_direction
	print(velocity)
	moving = true

func _on_move_timer_timeout():
	start_moving()

func _on_hitbox_component_area_entered(area):
	if area is HurtboxComponent:
		attack.origin = global_position
		area.take_attack(attack)

func _on_hurtbox_component_attacked(attack):
	$HealthComponent.take_damage(attack)

func _on_health_component_no_health(current_health):
	delete_self()

func delete_self():
	enemy_died.emit()
	queue_free()
	
func set_target(new_target: Node2D):
	$Target.set_target(new_target)