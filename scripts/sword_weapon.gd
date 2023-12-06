extends Node2D
@export var rotation_distance: float = 300
@export var rotation_speed: float = 0.7
@export var rotation_angle: float = -PI/2
@export var self_rotation_speed: float = 3.5
@export var damage: float = 1
@export var knockback: float = 1.0
@export var enemy_invulnerability_time: float = 1
var attack: Attack
var recent_enemies = {}
var current_level: int = 0
var upgrade_text: String = "Upgrade Sword"

# Called when the node enters the scene tree for the first time.
func _ready():
	attack = Attack.new()
	attack.damage = damage
	attack.knockback = knockback
	# TODO implement knockback
	
	PlayerData.sword_level_up.connect(level_up)

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
	
func get_level():
	return current_level

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

func level_up():
	current_level += 1
	match current_level:
		1:
			# ONCE AGAIN DO NOT MAKE THIS LEVEL 1
#			rotation_distance = 400
#			rotation_speed = 1.4
#			self_rotation_speed = 5
#			damage = 3
#			knockback = 1.0
#			attack.damage = damage
#			attack.knockback = knockback
#			enemy_invulnerability_time = 0.3
			PlayerData.sword_text = "Upgrade Sword 2\nIncrease Speed"
			PlayerData.spawn_sword.emit()
		2:
			rotation_speed = 0.8
			self_rotation_speed = 3.75
			PlayerData.sword_text = "Upgrade Sword 3\nIncrease distance"
		3:
			rotation_distance = 325
			enemy_invulnerability_time = 0.8
			PlayerData.sword_text = "Upgrade Sword 4\nIncrease damage"
		4:
			damage = 2
			attack.damage = damage
			PlayerData.sword_text = "Upgrade Sword 5\nIncrease Speed"
		5:
			rotation_speed = 1
			self_rotation_speed = 4
			PlayerData.sword_text = "Upgrade Sword 6\nIncrease Speed and Distance"
		6:
			rotation_distance = 375
			self_rotation_speed = 4.5
			rotation_speed = 1.2
			enemy_invulnerability_time = 0.6
			PlayerData.sword_text = "Upgrade Sword 7\nIncrease Distance and Damage"
		7:
			rotation_distance = 400
			damage = 3
			attack.damage = damage
			PlayerData.sword_text = "Upgrade Sword 8\nIncrease Speed"
		8:
			self_rotation_speed = 5
			rotation_speed = 1.4
			enemy_invulnerability_time = 0.3
			PlayerData.sword_text = "Upgrade Sword 9\nGreatly Increase Speed"
		9:
			self_rotation_speed = 8
			rotation_speed = 2
			enemy_invulnerability_time = 0.1
			PlayerData.sword_text = ""
			PlayerData.sword_max_level.emit()
		_:
			return
