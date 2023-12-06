class_name HealthComponent
extends Node

@export var MAX_HEALTH: float = 10
@export var invulnerability_time: float = 1
var health: float

signal no_health(current_health)

# Called when the node enters the scene tree for the first time.
func _ready():
	set_current_health(MAX_HEALTH)

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
	
func set_max_health(new_max_health: float, heal: bool):
	if new_max_health > 0:
		MAX_HEALTH = new_max_health
		if health:
			set_current_health(MAX_HEALTH)

func set_current_health(new_current_health: float):
	if new_current_health > 0 && new_current_health <= MAX_HEALTH:
		health = new_current_health
