extends Node2D

@export var hammer_attack_scene: PackedScene
@export var fire_rate: float = 2.2
@export var damage: float = 2.0
@export var knockback: float = 1.0
@export var fade_in_time: float = 2.8
@export var fade_out_time: float = 2
@export var swing_time: float = 3
@export var size_multiplier: float = 0.85

var fire_timer = Timer
var attack: Attack
var cool_down: bool = false
var right_enemies = {}
var left_enemies = {}
var current_level: int = 0
var upgrade_text: String = "Upgrade Hammer"

# Called when the node enters the scene tree for the first time.
func _ready():
	attack = Attack.new()
	attack.damage = damage
	attack.knockback = knockback
	
	scale = Vector2(size_multiplier, size_multiplier)
	
	PlayerData.hammer_level_up.connect(level_up)


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
	hammer_attack.fade_in_time = fade_in_time
	hammer_attack.fade_out_time = fade_out_time
	hammer_attack.swing_time = swing_time
	hammer_attack.scale = Vector2(size_multiplier, size_multiplier)
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
	
func get_level():
	return current_level

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

func level_up():
	current_level += 1
	match current_level:
		1:
			# TODO DONT MAKE THIS LEVEL 1. MAKE IT LEVEL 5 OR SOMETHING
#			fire_rate = 2.2
#			fade_in_time = 2.8
#			fade_out_time = 2
#			swing_time = 3
#			size_multiplier = 0.85
#			damage = 2.0
#			knockback = 1.0
#			attack.damage = damage
#			attack.knockback = knockback
			PlayerData.hammer_text = "Upgrade Hammer 2\nIncrease Size and Fire Rate"
			PlayerData.spawn_hammer.emit()
		2:
			size_multiplier = 0.88
			scale = Vector2(size_multiplier, size_multiplier)
			fire_rate = 2.1
			swing_time = 3.2
			PlayerData.hammer_text = "Upgrade Hammer 3\nIncrease Swing Speed"
		3:
			swing_time = 3.5
			fade_in_time = 2.9
			fade_out_time = 2.1
			PlayerData.hammer_text = "Upgrade Hammer 4\nIncrease Size and Fire Rate"
		4:
			size_multiplier = 0.9
			scale = Vector2(size_multiplier, size_multiplier)
			fire_rate = 2.3
			PlayerData.hammer_text = "Upgrade Hammer 5\nIncrease Size"
		5:
			size_multiplier = 1.0
			scale = Vector2(size_multiplier, size_multiplier)
			PlayerData.hammer_text = "Upgrade Hammer 6\nIncrease Damage"
		6:
			damage = 3
			attack.damage = damage
			PlayerData.hammer_text = "Upgrade Hammer 7\nIncrease Hammer Speed"
		7:
			swing_time = 4
			fade_in_time = 3.3
			fade_out_time = 2.2
			PlayerData.hammer_text = "Upgrade Hammer 8\nIncrease Fire Rate"
		8:
			fire_rate = 1.9
			fade_out_time = 2.4
			PlayerData.hammer_text = "Upgrade Hammer 9\nGreatly Increase Size and Speed"
		9:
			size_multiplier = 1.3
			scale = Vector2(size_multiplier, size_multiplier)
			fire_rate = 1.8
			swing_time = 5
			fade_in_time = 3.9
			fade_out_time = 2.6
			PlayerData.hammer_text = ""
			PlayerData.hammer_max_level.emit()
		_:
			return
