extends Node

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed && event.keycode == KEY_ESCAPE:
			get_tree().paused = !get_tree().paused
