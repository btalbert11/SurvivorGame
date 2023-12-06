extends Node2D
@export var Spike_Scene: PackedScene
@export var damage: float = 1
@export var attack_speed: float = 1.5
@export var spike_speed: float = 425
@export var number_of_spikes: int = 3
@export var max_attack_width: float = PI/8
@export var knockback: float = 0

var attack: Attack
var last_player_direction: Vector2
var cooldown_timer: Timer
var current_level: int = 0
var upgrade_text: String = "Upgrade Throwing Spikes"

# Called when the node enters the scene tree for the first time.
func _ready():
	attack = Attack.new()
	attack.damage = damage
	attack.knockback = knockback
	
	last_player_direction = Vector2(1,0).normalized()
	
	cooldown_timer = Timer.new()
	cooldown_timer.wait_time = attack_speed
	cooldown_timer.autostart = false
	cooldown_timer.one_shot = true
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	add_child(cooldown_timer)
	cooldown_timer.start()
	
	PlayerData.spike_level_up.connect(level_up)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		last_player_direction = direction

func fire():
	var spike_width = (max_attack_width * 2) / (number_of_spikes - 1)
	var curr_rotation = max_attack_width
	for i in range(0, number_of_spikes):
		spawn_spike(last_player_direction.rotated(curr_rotation))
		curr_rotation -= spike_width
	

func spawn_spike(direction: Vector2):
	var spike = Spike_Scene.instantiate()
	spike.speed = spike_speed
	spike.attack = attack
	spike.movement_direction = direction.normalized()
	get_tree().get_root().get_node("Game").add_child(spike)
	spike.global_position = global_position

func get_level():
	return current_level

func _on_cooldown_timer_timeout():
	fire()
	cooldown_timer.wait_time = attack_speed
	cooldown_timer.start()
	
func level_up():
	current_level += 1
	match current_level:
		1:
			# Variables to change upon level up
#			attack_speed = 1.5
#			spike_speed = 425
#			number_of_spikes = 3
#			max_attack_width = PI/8
#			knockback = 0
#			damage = 1
#			attack.damage = damage
#			attack.knockback = knockback
			PlayerData.spike_text = "Upgrade Throwing Spikes 2\nIncrease Number of Spikes"
			PlayerData.spawn_spike.emit()
		2:
			number_of_spikes = 4
			PlayerData.spike_text = "Upgrade Throwing Spikes 3\nIncrease Attack Speed"
		3:
			attack_speed = 1.3
			spike_speed = 450
			PlayerData.spike_text = "Upgrade Throwing Spikes 4\nIncrease Number of Spikes"
		4:
			number_of_spikes = 5
			max_attack_width = PI/8 + PI/16
			PlayerData.spike_text = "Upgrade Throwing Spikes 5\nIncrease Damage"
		5:
			damage = 2
			attack.damage = damage
			PlayerData.spike_text = "Upgrade Throwing Spikes 6\nIncrease Attack Speed"
		6:
			attack_speed = 1
			spike_speed = 500
			PlayerData.spike_text = "Upgrade Throwing Spikes 7\nIncrease Number of Spikes"
		7:
			number_of_spikes = 7
			PlayerData.spike_text = "Upgrade Throwing Spikes 8\nIncrease Number of Spikes and Attack Speed"
		8:
			number_of_spikes = 9
			attack_speed = 0.8
			spike_speed = 600
			PlayerData.spike_text = "Upgrade Throwing Spikes 9\nGreatly Increase Number of Spikes and Attack Speed"
		9:
			number_of_spikes = 10
			max_attack_width = PI/4
			attack_speed = 0.7
			spike_speed = 800
			PlayerData.spike_text = ""
			PlayerData.spike_max_level.emit()
		_:
			return
