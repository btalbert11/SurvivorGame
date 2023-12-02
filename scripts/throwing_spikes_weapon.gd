extends Node2D
@export var Spike_Scene: PackedScene
@export var damage: float = 1
@export var attack_speed: float = 1
@export var spike_speed: float = 500
@export var number_of_spikes: int = 9
@export var max_attack_width: float = PI/4
@export var knockback: float = 0

var attack: Attack
var last_player_direction: Vector2
var cooldown_timer: Timer

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
	get_tree().get_root().get_child(0).add_child(spike)
	spike.global_position = global_position
	

func _on_cooldown_timer_timeout():
	fire()
	cooldown_timer.start()
