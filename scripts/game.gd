extends Node2D
@export var Blox_Enemy: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var rng = RandomNumberGenerator.new()
	var rand_spawn = rng.randf_range(0, 500)
	if (rand_spawn < 4 && is_instance_valid($Player)):
		spawn_blox_enemy()

func spawn_blox_enemy():
	var screen_size = get_viewport().get_visible_rect().size
	var rng = RandomNumberGenerator.new()
	var rand_x = rng.randf_range(0, screen_size.x)
	var rand_y = rng.randf_range(0, screen_size.y)
	rand_x = $MainCamera.position.x - (screen_size.x/2) + rand_x
	rand_y = $MainCamera.position.y - (screen_size.y/2) + rand_y
	var pos = Vector2(rand_x, rand_y)
	if (pos.distance_to($Player.position) < 100):
		print("Player: " + str($Player.position))
		print("New Enemy: " + str(pos))
		return
	var blox_enemy = Blox_Enemy.instantiate()
	blox_enemy.target = $Player 
	add_child(blox_enemy)
	blox_enemy.position = pos


func _on_player_player_attacked(current_health, max_health):
	$CanvasLayer/Label/ColorRect.size.x = 200 * (current_health / max_health)
