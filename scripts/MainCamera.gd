extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("camera_zoom_in_DEBUG"):
		zoom += Vector2(.01, 0.01)
		print(zoom)
	elif Input.is_action_pressed("camera_zoom_out_DEBUG"):
		zoom -= Vector2(0.01, 0.01)
		print(zoom)
