extends CharacterBody2D

@export var SPEED: float = 300.0
@export var health_component: HealthComponent
@export var blink_speed: float = 4
@export var i_frames_timer: float = 1

signal player_died

var invicible: bool = false

func _process(delta):
	# Blink
	if invicible:
		$AnimatedSprite2D.modulate.a -= blink_speed * delta
		if $AnimatedSprite2D.modulate.a <= 0.3:
			$AnimatedSprite2D.modulate.a = 1

func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = direction * SPEED * delta
	else:
		velocity = Vector2.ZERO
	var collision = move_and_collide(velocity)
	

func _on_health_component_no_health(current_health):
	# Player died
	player_died.emit()
	queue_free()

func _on_invcicible_timer_timeout():
	invicible = false
	$AnimatedSprite2D.modulate.a = 1
	$HurtboxComponent/CollisionShape2D.set_deferred("disabled", false)
	set_collision_layer_value(1, 1)
	set_collision_mask_value(1, 1)


func _on_hurtbox_component_attacked(attack: Attack):
	if !invicible:
		health_component.take_damage(attack)
		# Set invicible state
		invicible = true
		var timer = Timer.new()
		timer.wait_time = i_frames_timer
		timer.one_shot = true
		timer.autostart = false
		timer.connect("timeout", _on_invcicible_timer_timeout)
		add_child(timer)
		timer.start()
		# disable hurtbox
		$HurtboxComponent/CollisionShape2D.set_deferred("disabled", true)
		set_collision_layer_value(1, 0)
		set_collision_mask_value(1, 0)
