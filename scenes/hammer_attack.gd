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

# Called when the node enters the scene tree for the first time.
func _ready():
	fading_in = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fading_in:
		$Sprite2D.modulate.a += fade_in_time * delta
		if $Sprite2D.modulate.a >= 1:
			fading_in = false
			swinging = true
	if swinging && !left:
		var to_rotate = swing_time * delta
		rotation_angle += to_rotate
		if rotation_angle >= PI/2:
			# TODO Figure out this mat TODO
			to_rotate = rotation_angle - (PI/2)
			$Sprite2D.transform = $Sprite2D.transform.rotated(to_rotate)
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
