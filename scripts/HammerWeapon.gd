extends Node2D

@export var hammer_attack_scene: PackedScene
@export var fire_rate: float = 1.8
@export var damage: float = 4.0
@export var knockback: float = 1.0
var fire_timer = Timer
var attack: Attack
var cool_down: bool = false
var right_enemies = {}
var left_enemies = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	attack = Attack.new()
	attack.damage = damage
	attack.knockback = knockback
	# TODO add knockback to hammer attack


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func fire():
	if cool_down:
		return
	var hammer_attack = hammer_attack_scene.instantiate()
	var right: bool
	if right_enemies.size() >= left_enemies.size():
		right = true
	else:
		right = false
	hammer_attack.init(right)
	attack.origin = global_position
	hammer_attack.attack = attack
	call_deferred("add_child", hammer_attack)
	disable_hitbox()
	set_timer()
	cool_down = true
	

func disable_hitbox():
	$HitboxComponentLeft.disable()
	$HitboxComponentRight.disable()

func enable_hitbox():
	$HitboxComponentLeft.enable()
	$HitboxComponentRight.enable()

func set_timer():
	fire_timer = Timer.new()
	fire_timer.wait_time = fire_rate
	fire_timer.one_shot = true
	fire_timer.autostart = false
	fire_timer.timeout.connect(_on_fire_timer_timeout)
	add_child(fire_timer)
	fire_timer.start()
	
func _on_fire_timer_timeout():
	enable_hitbox()
	cool_down = false

func _on_hitbox_component_right_area_entered(area):
	var parent = area.get_owner()
	if parent.is_in_group("Enemies"):
		right_enemies[parent.get_instance_id()] = parent
		call_deferred("fire")


func _on_hitbox_component_left_area_entered(area):
	var parent = area.get_owner()
	if parent.is_in_group("Enemies"):
		left_enemies[parent.get_instance_id()] = parent
		call_deferred("fire")


func _on_hitbox_component_right_area_exited(area):
	var parent = area.get_owner()
	if parent.is_in_group("Enemies"):
		right_enemies.erase(parent.get_instance_id())

func _on_hitbox_component_left_area_exited(area):
	var parent = area.get_owner()
	if parent.is_in_group("Enemies"):
		left_enemies.erase(parent.get_instance_id())
