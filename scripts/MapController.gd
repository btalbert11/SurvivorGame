extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func move_map(side):
	match side:
		"Right":
			position.x += 1632
		"Top":
			position.y -= 1024
		"Left":
			position.x -= 1632
		"Bottom":
			position.y += 1024

func _on_right_trigger_body_entered(body):
	if body.is_in_group("Player"):
		move_map("Right")


func _on_top_trigger_body_entered(body):
	if body.is_in_group("Player"):
		move_map("Top")


func _on_left_trigger_body_entered(body):
	if body.is_in_group("Player"):
		move_map("Left")


func _on_bottom_trigger_body_entered(body):
	if body.is_in_group("Player"):
		move_map("Bottom")
