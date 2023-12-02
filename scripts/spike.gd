extends Node2D

@export var speed: float = 10

var movement_direction: Vector2
var velocity: Vector2
var attack: Attack

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = movement_direction * speed
	#rotate towards movement_direction
	rotation = movement_direction.angle() + PI/2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	position += velocity * delta


func _on_hitbox_component_area_entered(area):
	if area is HurtboxComponent:
		area.take_attack(attack)


func _on_visible_on_screen_notifier_2d_screen_exited():
	delete_self()

func delete_self():
	queue_free()
