extends Node2D

@export var missle_scene: PackedScene
@export var fire_rate: float = 1
@export var missle_speed: float = 200
var attack: Attack
var fire_timer: float = 0
var damage: float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	attack = Attack.new()
	attack.damage = damage

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fire_timer += delta
	if $HitboxComponent.has_overlapping_areas() && fire_timer > fire_rate:
		fire()
		fire_timer = 0

func fire():
	var missle = missle_scene.instantiate()
	missle.attack = attack
	var rng = RandomNumberGenerator.new()
	var rand_x = rng.randf_range(-100, 100)
	var rand_y = rng.randf_range(-100, 100)
	missle.velocity.x = rand_x
	missle.velocity.y = rand_y
	missle.global_position = global_position
	get_tree().root.get_child(0).add_child(missle)

