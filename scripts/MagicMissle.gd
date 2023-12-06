extends Node2D

@export var missle_scene: PackedScene
@export var fire_rate: float = 1
@export var missle_speed: float = 200
@export var acceleration_value: float = 400
var attack: Attack
var fire_timer: float = 0
var damage: float = 1
var current_level = 1
var upgrade_text: String = "Upgrade Magic Missle"

# Called when the node enters the scene tree for the first time.
func _ready():
	attack = Attack.new()
	attack.damage = damage

	PlayerData.magic_missle_level_up.connect(level_up)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fire_timer += delta
	if $HitboxComponent.has_overlapping_areas() && fire_timer > fire_rate:
		fire()
		fire_timer = 0

func fire():
	var missle = missle_scene.instantiate()
	missle.attack = attack
	missle.SPEED_MAX = missle_speed
	missle.acceleration_value = acceleration_value
	var rng = RandomNumberGenerator.new()
	var rand_x = rng.randf_range(-100, 100)
	var rand_y = rng.randf_range(-100, 100)
	missle.velocity.x = rand_x
	missle.velocity.y = rand_y
	missle.global_position = global_position
	get_tree().get_root().get_node("Game").add_child(missle)
	
func get_level():
	return current_level

func level_up():
	current_level += 1
	match current_level:
		1:
			# all weapon variables I can edit with level
#			damage = 1
#			attack.damage = damage
#			fire_rate = 1
#			missle_speed = 200
#			acceleration_value = 400
			PlayerData.magic_text = "Upgrade Magic Missle 2\nIncrease fire rate"
			PlayerData.spawn_magic_missle.emit()

		2:
			missle_speed = 250
			acceleration_value = 420
			fire_rate = 0.8
			PlayerData.magic_text = "Upgrade Magic Missle 3\nIncrease Speed"
		3:
			missle_speed = 300
			acceleration_value = 450
			PlayerData.magic_text = "Upgrade Magic Missle 4\nIncrease Fire Rate"
		4:
			missle_speed = 325
			fire_rate = 0.65
			PlayerData.magic_text = "Upgrade Magic Missle 5\nIncrease Fire Rate"
		5:
			fire_rate = 0.55
			acceleration_value = 500
			PlayerData.magic_text = "Upgrade Magic Missle 6\nIncrease Damamge"
		6:
			missle_speed = 350
			acceleration_value = 525
			damage = 2
			attack.damage = damage
			PlayerData.magic_text = "Upgrade Magic Missle 7\nIncrease Fire Rate and Speed"
		7:
			fire_rate = 0.4
			missle_speed = 450
			acceleration_value = 600
			PlayerData.magic_text = "Upgrade Magic Missle 8\nIncrease Fire Rate and Speed"
		8:
			fire_rate = 0.35
			missle_speed = 650
			acceleration_value = 800
			PlayerData.magic_text = "Upgrade Magic Missle 9\nGreatly Increase Fire Rate and Speed"
		9:
			fire_rate = 0.2
			missle_speed = 750
			acceleration_value = 950
			PlayerData.magic_text = ""
			PlayerData.magic_max_level.emit()
		_:
			return
