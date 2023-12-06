extends CharacterBody2D

@export var SPEED: float = 300.0
@export var health_component: HealthComponent
@export var blink_speed: float = 4
@export var i_frames_timer: float = 0.5
@export var level_cap: int = 36
@export var rotation_rate: float = 0.06

var current_experience: int = 0
var current_level: int = 1

signal player_died
signal player_attacked(current_health: float, max_health: float)
signal leveled_up

var invincible: bool = false

func _ready():
	PlayerData.spawn_magic_missle.connect(spawn_magic_missle)
	PlayerData.spawn_hammer.connect(spawn_hammer)
	PlayerData.spawn_sword.connect(spawn_sword)
	PlayerData.spawn_spike.connect(spawn_spike)

func _process(delta):
	# Blink
	if invincible:
		$AnimatedSprite2D.modulate.a -= blink_speed * delta
		if $AnimatedSprite2D.modulate.a <= 0.3:
			$AnimatedSprite2D.modulate.a = 1

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = direction.normalized() * SPEED * delta
		if velocity.x < 0:
			$AnimatedSprite2D.rotation -= rotation_rate
		elif velocity.x > 0:
			$AnimatedSprite2D.rotation += rotation_rate
		elif velocity.y > 0:
			$AnimatedSprite2D.rotation -= rotation_rate
		elif velocity.y < 0:
			$AnimatedSprite2D.rotation += rotation_rate
	else:
		velocity = Vector2.ZERO
	
	var collision = move_and_collide(velocity)

func _on_health_component_no_health(current_health):
	# Player died
	player_died.emit()
	queue_free()

func _on_invcicible_timer_timeout():
	invincible = false
	$AnimatedSprite2D.modulate.a = 1
	$HurtboxComponent.enable()
	set_collision_layer_value(1, 1)
	set_collision_mask_value(1, 1)

func _on_hurtbox_component_attacked(attack: Attack):
	if !invincible:
		health_component.take_damage(attack)
		set_invincible()
		disable_collision()
		player_attacked.emit(health_component.get_current_health(), health_component.get_max_health())

func disable_collision():
	# disable hurtbox
	$HurtboxComponent.disable()
	# disable enemy collision
	set_collision_layer_value(6, 0)
	set_collision_mask_value(6, 0)

func enable_collision():
	# enable hurtbox
	$HurtboxComponent.enable()
	# enable enemy collision
	set_collision_layer_value(6, 0)
	set_collision_mask_value(6, 0)

func obtain_experience(experience) -> float:
	if current_level >= level_cap:
		return 0
	current_experience += experience
	if current_experience >= get_xp_requirement(): #TODO MAKE LEVEL UP FUNCTION
		current_level += 1
		print(str(current_level) + ", " + str(get_xp_requirement()))
		var cur_health = $HealthComponent.get_max_health()
		$HealthComponent.set_max_health(cur_health + 2, true)
		leveled_up.emit()
		print(current_level)
		current_experience = 0
	# return ratio to set exp bar size
	return current_experience / get_xp_requirement()

func spawn_magic_missle():
	$MagicMissle.visible = true
	$MagicMissle.process_mode = Node.PROCESS_MODE_INHERIT

func spawn_hammer():
	$HammerWeapon.visible = true
	$HammerWeapon.process_mode = Node.PROCESS_MODE_INHERIT

func spawn_sword():
	$SwordWeapon.visible = true
	$SwordWeapon.process_mode = Node.PROCESS_MODE_INHERIT

func spawn_spike():
	$ThrowingSpikesWeapon.visible = true
	$ThrowingSpikesWeapon .process_mode = Node.PROCESS_MODE_INHERIT

func get_xp_requirement() -> float:
	var x = current_level
	return ((pow(x, 1/2))) + (4*x) + ((1/500)*pow(x,2)) 

func set_invincible():
	# Set invicible state
	invincible = true
	var timer = Timer.new()
	timer.wait_time = i_frames_timer
	timer.one_shot = true
	timer.autostart = false
	timer.connect("timeout", _on_invcicible_timer_timeout)
	add_child(timer)
	timer.start()

