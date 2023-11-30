extends Node2D
@export var fade_speed: float = 3
@export var shrink_speed: float = 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite2D.modulate.a -= fade_speed * delta
	$Sprite2D.scale -= Vector2(shrink_speed * delta, shrink_speed * delta)
	if $Sprite2D.modulate.a <= 0:
		queue_free()
