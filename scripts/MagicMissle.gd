extends Node2D

@export var missle_scene: PackedScene
@export var fire_rate: float = 1
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
	# Get closest enemy
	var enemies = $HitboxComponent.get_overlapping_areas()
	var target = enemies[0]
	for enemy in enemies:
		if global_position.distance_to(target.global_position) < global_position.distance_to(enemy.global_position):
			target = enemy
	# Fire
	var missle = missle_scene.instantiate()
	missle.attack = attack
	missle.target = target.get_parent()
	add_child(missle)
