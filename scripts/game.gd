extends Node2D
@export var Blox_Enemy: PackedScene
@export var Dash_Enemy: PackedScene
@export var Bounce_Enemy: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var rng = RandomNumberGenerator.new()
	var rand_spawn = rng.randf_range(0, 500)
	if (rand_spawn < 4 && is_instance_valid($Player)):
		spawn_blox_enemy()
	
	rand_spawn = rng.randf_range(0, 500)
	if (rand_spawn < 1 && is_instance_valid($Player)):
		spawn_dash_enemy()

	rand_spawn = rng.randf_range(0, 500)
	if (rand_spawn < 0.5 && is_instance_valid($Player)):
		spawn_bounce_enemy()

func spawn_blox_enemy():
	var pos = get_random_screen_point()
	if pos == Vector2.ZERO:
		return
	var blox_enemy = Blox_Enemy.instantiate()
	blox_enemy.set_target($Player) 
	add_child(blox_enemy)
	blox_enemy.position = pos
	
func spawn_dash_enemy():
	var pos = get_random_screen_point()
	if pos == Vector2.ZERO:
		return
	var dash_enemy = Dash_Enemy.instantiate()
	dash_enemy.set_target($Player)
	add_child(dash_enemy)
	dash_enemy.position = pos
	
func spawn_bounce_enemy():
	var pos = get_random_screen_point()
	if pos == Vector2.ZERO:
		return
	var bounce_enemy = Bounce_Enemy.instantiate()
	bounce_enemy.set_target($Player)
	add_child(bounce_enemy)
	bounce_enemy.position = pos


func get_random_screen_point() -> Vector2:
	var screen_size = get_viewport().get_visible_rect().size
	var rng = RandomNumberGenerator.new()
	var rand_x = rng.randf_range(0, screen_size.x)
	var rand_y = rng.randf_range(0, screen_size.y)
	rand_x = $MainCamera.position.x - (screen_size.x/2) + rand_x
	rand_y = $MainCamera.position.y - (screen_size.y/2) + rand_y
	var pos = Vector2(rand_x, rand_y)
	if (pos.distance_to($Player.position) < 100):
		return Vector2.ZERO
	return pos

func _on_player_player_attacked(current_health, max_health):
	$CanvasLayer/Label/ColorRect.size.x = 200 * (current_health / max_health)
