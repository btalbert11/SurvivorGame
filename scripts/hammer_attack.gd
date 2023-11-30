extends Node2D
var attack: Attack
var left: bool = false
var fade_in_time: float = 3.4
var fade_out_time: float = 2.6
var swing_time: float = 5.5
var fading_in: bool = false
var swinging: bool = false
var fading_out: bool = false
var rotation_angle: float = 0.0
var right_side: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	fading_in = true

func init(direction: bool):
	right_side = direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fading_in:
		$Sprite2D.modulate.a += fade_in_time * delta
		if $Sprite2D.modulate.a >= 1:
			fading_in = false
			swinging = true
	if swinging && !left:
		var to_rotate = swing_time * delta
		if (!right_side):
			to_rotate = 0 - to_rotate
		rotation_angle += to_rotate
		if rotation_angle >= PI/2 || rotation_angle <= -PI/2:
			deal_damage()
			swinging = false
			fading_out = true
		else:
			$Sprite2D.transform = $Sprite2D.transform.rotated(to_rotate)
	if fading_out:
		$Sprite2D.modulate.a -= fade_out_time * delta
		if $Sprite2D.modulate.a <= 0:
			delete_self()

func delete_self():
	queue_free()

func deal_damage():
	# Get all collisions
	if (right_side):
		for body in $HitboxComponentRight.get_overlapping_areas():
			body.take_attack(attack)
	else:
		for body in $HitboxComponentLeft.get_overlapping_areas():
			body.take_attack(attack)
