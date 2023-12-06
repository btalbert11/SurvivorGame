extends Node2D
@export var Blox_Enemy: PackedScene
@export var Dash_Enemy: PackedScene
@export var Bounce_Enemy: PackedScene
@export var Big_Bad_Enemy: PackedScene
@export var Pumpkin_Enemy: PackedScene

@export var blox_spawn_rate: float = 3
@export var dash_spawn_rate: float = 0
@export var bounce_spawn_rate: float = 0
@export var big_bad_spawn_rate: float = 0
@export var player_health_bar_size: float = 200
@export var adjust_time: float = 5.01

var levels: Levels
var level_timer: Timer
var adjust_spawn_rates_timer: Timer

var current_level: int

# Called when the node enters the scene tree for the first time.
func _ready():
	# init variables
	levels = Levels.new()
	current_level = 1
	# Setup level timer
	level_timer = Timer.new()
	level_timer.wait_time = levels.get_level_time(current_level)
	level_timer.one_shot = true
	level_timer.autostart = false
	level_timer.timeout.connect(_on_level_timer_timeout)
	add_child(level_timer)
	level_timer.start()
	# Set up timer to adjust spawn rates based on number of enemies on screen
	adjust_spawn_rates_timer = Timer.new()
	adjust_spawn_rates_timer.wait_time = adjust_time
	adjust_spawn_rates_timer.autostart = false
	adjust_spawn_rates_timer.one_shot = true
	adjust_spawn_rates_timer.timeout.connect(_on_adjust_timer_timeout)
	add_child(adjust_spawn_rates_timer)
	adjust_spawn_rates_timer.start()
	
	$BloxEnemy.set_target($Player)
	$BloxEnemy2.set_target($Player)
	$BloxEnemy3.set_target($Player)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Set level timer countdown
	$HealthBarLayer/Level.text = "Level " + str(current_level) + ": " + str(int(level_timer.time_left))
	
	var rng = RandomNumberGenerator.new()
	var rand_spawn = rng.randf_range(0, 500)
	if (rand_spawn < blox_spawn_rate && is_instance_valid($Player)):
		spawn_enemy(Blox_Enemy)

	rand_spawn = rng.randf_range(0, 500)
	if (rand_spawn < dash_spawn_rate && is_instance_valid($Player)):
		spawn_enemy(Dash_Enemy)

	rand_spawn = rng.randf_range(0, 500)
	if (rand_spawn < bounce_spawn_rate && is_instance_valid($Player)):
		spawn_enemy(Bounce_Enemy)

	rand_spawn = rng.randf_range(0, 500)
	if (rand_spawn < big_bad_spawn_rate && is_instance_valid($Player)):
		spawn_enemy(Big_Bad_Enemy)


func spawn_enemy(enemy_type):
	if !is_instance_valid($Player):
		return
	var pos = get_random_screen_point()
	while pos == Vector2.ZERO:
		pos = get_random_screen_point()
	var enemy = enemy_type.instantiate()
	enemy.set_target($Player)
	enemy.enemy_died.connect(_on_enemy_died)
	add_child(enemy)
	enemy.position = pos

func get_random_screen_point() -> Vector2:
	var screen_size = get_viewport().get_visible_rect().size
	var rng = RandomNumberGenerator.new()
	var rand_x = rng.randf_range(0, screen_size.x)
	var rand_y = rng.randf_range(0, screen_size.y)
	rand_x = $MainCamera.position.x - (screen_size.x/2) + rand_x
	rand_y = $MainCamera.position.y - (screen_size.y/2) + rand_y
	var pos = Vector2(rand_x, rand_y)
	if (is_instance_valid($Player) && pos.distance_to($Player.position) < 200):
		return Vector2.ZERO
	return pos
	
func update_level_up_labels():
		$LevelUpScreen/MagicUpgrade.text = PlayerData.magic_text
		$LevelUpScreen/HammerUpgrade.text = PlayerData.hammer_text
		$LevelUpScreen/SwordUpgrade.text = PlayerData.sword_text
		$LevelUpScreen/SpikeUpgrade.text = PlayerData.spike_text
	
func _on_enemy_died(experience):
	if is_instance_valid($Player):
		var xp_ratio = $Player.obtain_experience(experience)
		$HealthBarLayer/Experience/ColorRect.size.x = player_health_bar_size * xp_ratio

func _on_adjust_timer_timeout():
	if current_level >= 14:
		return
	# TODO 
	# Adjust spawn rates based on enemies on screen to
	# make sure there are not too many or too few
	var bloxs = get_tree().get_nodes_in_group("Blox")
	var dashes = get_tree().get_nodes_in_group("Dash")
	var bounces = get_tree().get_nodes_in_group("Bounce")
	var BigBads = get_tree().get_nodes_in_group("BigBad")
	
	if len(bloxs) == 0:
		spawn_enemy(Blox_Enemy)
	if len(bloxs) < 5:
		blox_spawn_rate *= 1.4
	if len(bloxs) > 20:
		blox_spawn_rate *= 0.8
	
	if len(dashes) == 0 && current_level >= 2:
		spawn_enemy(Dash_Enemy)
	if len(dashes) < 3:
		dash_spawn_rate *= 1.4
	if len(dashes) > 10:
		dash_spawn_rate *= 0.8

	if len(bounces) == 0 && current_level >= 5:
		spawn_enemy(Bounce_Enemy)
	if len(bounces) < 2:
		bounce_spawn_rate *= 1.4
	if len(bounces) > 5:
		bounce_spawn_rate *= 0.8

	if len(BigBads) < 1:
		big_bad_spawn_rate *= 2
	if len(BigBads) == 2:
		big_bad_spawn_rate *= 0.6
	if len(BigBads) > 3:
		big_bad_spawn_rate *= 0.2
	
	adjust_spawn_rates_timer.start(adjust_time)


func _on_level_timer_timeout():
	current_level += 1
	# Spawn boss after final wave
	if current_level >= 13:
		spawn_enemy(Pumpkin_Enemy)
	# Set new spawn rates
	var new_rates = levels.get_spawn_rates(current_level)
	blox_spawn_rate = new_rates[0]
	dash_spawn_rate = new_rates[1]
	bounce_spawn_rate = new_rates[2]
	big_bad_spawn_rate = new_rates[3]
	
	if current_level >= 2 && current_level < 5:
		spawn_enemy(Dash_Enemy)
	if current_level >= 5 && current_level < 8:
		spawn_enemy(Bounce_Enemy)
	if current_level >= 8:
		spawn_enemy(Big_Bad_Enemy)
	spawn_enemy(Blox_Enemy)
	
	level_timer.wait_time = levels.get_level_time(current_level)
	level_timer.start()

func _on_player_player_attacked(current_health, max_health):
	$HealthBarLayer/Label/ColorRect.size.x = player_health_bar_size * (current_health / max_health)

func _on_player_leveled_up():
	# Get weapon levels TODO
	update_level_up_labels()
	$LevelUpScreen.visible = true
	get_tree().paused = true

