extends Node2D
@export var Blox_Enemy: PackedScene
@export var Dash_Enemy: PackedScene
@export var Bounce_Enemy: PackedScene
@export var Big_Bad_Enemy: PackedScene

@export var blox_spawn_rate: float = 4
@export var dash_spawn_rate: float = 0.8
@export var bounce_spawn_rate: float = 0.5
@export var big_bad_spawn_rate: float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	$BigBadGuy.set_target($Player)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	var pos = get_random_screen_point()
	if pos == Vector2.ZERO:
		return
	var enemy = enemy_type.instantiate()
	enemy.set_target($Player)
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
	if (pos.distance_to($Player.position) < 100):
		return Vector2.ZERO
	return pos

func _on_player_player_attacked(current_health, max_health):
	$CanvasLayer/Label/ColorRect.size.x = 200 * (current_health / max_health)
