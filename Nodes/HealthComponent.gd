class_name HealthComponent
extends Node

@export var MAX_HEALTH: float = 10
var health: float

signal no_health(current_health)

# Called when the node enters the scene tree for the first time.
func _ready():
	health = MAX_HEALTH

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func take_damage(attack: Attack):
	health -= attack.damage
	if health <= 0:
		no_health.emit(health)

func get_current_health() -> float:
	return health

func get_max_health() -> float:
	return MAX_HEALTH
