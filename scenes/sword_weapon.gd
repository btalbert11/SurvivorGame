extends Node2D
@export var rotation_distance: float = 400
@export var rotation_speed: float = 1.4
@export var rotation_angle: float = -PI/2
@export var self_rotation_speed: float = 5
@export var damage: float = 3
@export var knockback: float = 1.0
@export var enemy_invulnerability_time: float = 0.3
var attack: Attack
var recent_enemies = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	attack = Attack.new()
	attack.damage = damage
	attack.knockback = knockback
	# TODO implement knockback

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	# Rotate around character
	rotation_angle += rotation_speed * delta
	$Rotator.position = Vector2(cos(rotation_angle), sin(rotation_angle)) * rotation_distance
	
	# Rotate around self
	$Rotator.rotation -= self_rotation_speed * delta

func create_timer(enemy_id):
	var timer = Timer.new()
	timer.wait_time = enemy_invulnerability_time
	timer.autostart = false
	timer.one_shot = true
	var callable = Callable(self, "_on_enemy_invulnerability_timeout").bind(enemy_id)
	timer.connect("timeout", callable)
	add_child(timer)
	timer.start()

func _on_hitbox_component_area_entered(area):
	if area is HurtboxComponent:
		if recent_enemies.has(area.get_instance_id()):
			return
		recent_enemies[area.get_instance_id()] = area
		create_timer(area.get_instance_id())
		area.take_attack(attack)

func _on_enemy_invulnerability_timeout(enemy_id):
	if recent_enemies.has(enemy_id):
		recent_enemies.erase(enemy_id)
	else:
		print("INCORRECT ENEMY ID")
		get_tree().quit(-1)
